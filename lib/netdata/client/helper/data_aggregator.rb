module Netdata
  module Client
    module Helper
      class DataAggregator
        def parse_alarms(data)
          out = data.dup
          out["alarms"] = nil

          return {} if data["alarms"].empty?

          data['alarms'].each do |alarm|
            alarm_name = alarm[0]
            alarm_value = alarm[1]
            out["alarms"] = alarm_value unless alarm_value["recipient"] == 'silent'
          end

          out
        end

        def get_cpu(url)
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
        end

        def get_cpu_users(url)
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
            users_cpu_value_history = users_cpu_resp["result"][0..119]
            users_cpu_users = users_cpu_resp["dimension_names"]

            [users_cpu_value_history, users_cpu_value, users_cpu_users]
        end
      end
    end
  end
end