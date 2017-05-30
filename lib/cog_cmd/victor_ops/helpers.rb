require 'net/http'

module CogCmd
  module VictorOps
    module Helpers
      API = 'api.victorops.com'.freeze
      PORT = 443
      BASE_PATH = '/api-public/v1'.freeze

      def http_client
        http = Net::HTTP.new API, PORT
        http.use_ssl = true
        http
      end

      def headers
        {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'X-VO-Api-Id' => ENV['VICTOROPS_API_ID'],
          'X-VO-Api-Key' => ENV['VICTOROPS_API_KEY']
        }
      end

      def api_id; ENV['VICTOROPS_API_ID']; end
      def api_key; ENV['VICTOROPS_API_KEY']; end
    end
  end
end
