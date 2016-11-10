module Netdata
  module Client
    class Controller
      def initialize
        @network = Helper::Network.new
        @config = ::YAML::load_file(File.expand_path("~/.netdatacli.yml"))
      end

      def check
        aggregator = {}

        return unless @config

        @config["instances"].each do |url|
          alarms = @network.get("alarms", url, {})

          return unless alarms

          alarms_resp = JSON.parse(alarms.body)

          # system CPU stats
          cpu_opts = {
            "chart" => "system.cpu",
            "format" => "array",
            "points" => 54,
            "group" => "average",
            "options" => "absolute|jsonwrap|nonzero",
            "after" => -540
          }
          cpu = @network.get("data", url, cpu_opts)
          cpu_value = JSON.parse(cpu.body)["result"].first

          # CPU on a per-user basis
          users_cpu_opts = {
            "chart" => "users.cpu",
            "format" => "array",
            "points" => 54,
            "group" => "average",
            "options" => "absolute|jsonwrap|nonzero",
            "after" => -540
          }
          users_cpu = @network.get("data", url, users_cpu_opts)
          users_cpu_resp = JSON.parse(users_cpu.body)
          users_cpu_value = users_cpu_resp["result"].first
          users_cpu_users = users_cpu_resp["dimension_names"]

          aggregator[alarms_resp["hostname"]] = {}
          aggregator[alarms_resp["hostname"]]["cpu"] = cpu_value
          aggregator[alarms_resp["hostname"]]["users_cpu"] = { "users" => users_cpu_users, "value" => users_cpu_value }
          aggregator[alarms_resp["hostname"]]["alarms"] = alarms_resp unless alarms_resp["alarms"].empty?
        end

        pp aggregator

        aggregator.each_pair do |host, data|
          # new thread for each host so we can see mulitple notifications
          Thread.new {
            message = ""
            message += "CPU Warning - #{data["cpu"].round(2)}%\n" if data["cpu"] > 50
            message += "#{data['users_cpu']['users'].size} system users active (#{data["users_cpu"]["value"].round(2)}% CPU)\n" if data["users_cpu"]["value"] > 50
            message += "Alarms are ringing" if data["alarms"]

            Notify.bubble(message, "Netdata Warning on #{host}") if message.size > 0
          }.join
        end
      end
    end
  end
end