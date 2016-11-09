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

          aggregator[alarms_resp["hostname"]] = {}
          aggregator[alarms_resp["hostname"]]["cpu"] = cpu_value
        end

        aggregator.each_pair do |host, data|
          Notify.bubble("CPU Warning on #{host} - #{data["cpu"]}", "Netdata Warning") if data["cpu"] > 50
        end
      end
    end
  end
end