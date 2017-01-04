module Netdata
  module Client
    module Helper
      # Perform HTTP requests
      class Network
        # Access the configuration object instance externally
        attr_accessor :config

        # Perform a GET request to a specified URL
        # Params:
        # +url+:: The URL you want to hit
        # +key+:: The authentication key to pass via headers to the URL
        def get(endpoint, url, args, version = 'v1')
          qs = build_qs(args)
          req_url = "#{url}/api/#{version}/#{endpoint}?#{qs}"

          request(req_url, :GET)
        end

        # Perform a POST request to a specified URL
        # Params:
        # +url+:: The URL you want to hit
        # +key+:: The authentication key to pass via headers to the URL
        def post(endpoint, url, args, version = 'v1')
          qs = build_qs(args)
          req_url = "#{url}/api/#{version}/#{endpoint}?#{qs}"

          request(req_url, :POST)
        end

        private

        # Create and send the HTTP request
        # Params:
        # +url+:: The URL you want to hit
        # +type+:: The HTTP method to send
        # +key+:: The authentication key to pass via headers to the URL
        def request(url, type)
          url = URI(URI.encode(url))
          type ||= :GET
          req_path = "#{url.path}?#{url.query}"

          if type == :GET
            req = Net::HTTP::Get.new(req_path)
          elsif type == :POST
            req = Net::HTTP::Post.new(req_path)
          end

          res = Net::HTTP.new(url.host, url.port).start do |http|
            http.request(req)
          end

          res
        end

        # Create a query string from a hash
        # Params:
        # +args+:: The hash
        def build_qs(args)
          args.map { |k, v| "#{k}=#{v}" }.join('&')
        end
      end
    end
  end
end
