module Netdata
  module Client
    class Controller
      def initialize
        @network = Helper::Network.new
        @aggregator = Helper::DataAggregator.new
        @config = ::YAML::load_file(File.expand_path("~/.netdatacli.yml"))
      end

      def report_interval_2_mins
        aggregator = {}
        threshold = 50 # numbers higher than this should trigger notifications

        return unless @config

        @config["instances"].each do |url|
          alarms = @network.get("alarms", url, {})

          return unless alarms

          alarms_resp = @aggregator.parse_alarms(JSON.parse(alarms.body))

          # system CPU stats
          cpu_value = @aggregator.get_cpu(url)

          # CPU on a per-user basis
          users_cpu_value_history, users_cpu_value, users_cpu_users = @aggregator.get_cpu_users(url)

          aggregator[alarms_resp["hostname"]] = {}
          aggregator[alarms_resp["hostname"]][:cpu] = cpu_value
          aggregator[alarms_resp["hostname"]][:users_cpu] = { users: users_cpu_users, value: users_cpu_value, history: users_cpu_value_history.select { |val| val > threshold } }
          aggregator[alarms_resp["hostname"]][:alarms] = alarms_resp unless alarms_resp["alarms"].nil?
        end

        pp aggregator

        aggregator.each_pair do |host, data|
          # new thread for each host so we can see mulitple notifications
          Thread.new {
            message = ""
            message += "CPU Warning - #{data[:cpu].round(2)}%\n" if data[:cpu] > threshold
            message += "#{data[:users_cpu][:users].size} system users active (#{data[:users_cpu][:value].round(2)}% CPU)\n" if data[:users_cpu][:value] > threshold
            message += "Alarms are ringing\n" if data[:alarms]
            message += "#{data[:users_cpu][:history].size} CPU instance(s) > #{threshold}%\n" if data[:users_cpu][:history].size > 0

            Notify.bubble(message, "Netdata Warning on #{host}") if message.size > 0
          }.join
        end
      end
    end
  end
end