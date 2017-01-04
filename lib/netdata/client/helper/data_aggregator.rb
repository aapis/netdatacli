module Netdata
  module Client
    module Helper
      # Organize and parse data for certain flags
      class DataAggregator
        # Initializer
        def initialize
          @network = Network.new

          # CPU usage per-user request options
          @users_cpu_opts = {
            'chart' => 'users.cpu',
            'format' => 'array',
            'points' => 54,
            'group' => 'average',
            'options' => 'absolute|jsonwrap|nonzero',
            'after' => -540
          }

          # raw CPU request options
          @cpu_opts = {
            'chart' => 'system.cpu',
            'format' => 'array',
            'points' => 54,
            'group' => 'average',
            'options' => 'absolute|jsonwrap|nonzero',
            'after' => -540
          }
        end

        # ...
        # Params:
        def parse_alarms(data)
          out = data.dup

          return { 'hostname' => data['hostname'] } if data['alarms'].empty?

          out['alarms'] = nil

          data['alarms'].each do |alarm|
            alarm_value = alarm[1]
            recipient = alarm_value['recipient']
            out['alarms'] = alarm_value unless recipient == 'silent'
          end

          out
        end

        # ...
        # Params:
        def get_cpu(url)
          cpu = @network.get('data', url, @cpu_opts)

          JSON.parse(cpu.body)['result'].first
        end

        # ...
        # Params:
        def get_cpu_users(url)
          users_cpu = @network.get('data', url, @users_cpu_opts)

          users_cpu_resp = JSON.parse(users_cpu.body)
          users_cpu_value = users_cpu_resp['result'].first
          users_cpu_value_history = users_cpu_resp['result'][0..119]
          users_cpu_users = users_cpu_resp['dimension_names']

          [users_cpu_value_history, users_cpu_value, users_cpu_users]
        end
      end
    end
  end
end
