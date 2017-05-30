#!/usr/bin/env ruby

require 'cog/command'
require 'net/http'
require 'json'
module CogCmd
  module VictorOps
    class Ack < Cog::Command
      API = 'api.victorops.com'.freeze
      PORT = 443
      PATH = '/api-public/v1/incidents/ack'.freeze

      # curl -X PATCH --header 'Content-Type: application/json' \
      # --header 'Accept: application/json' --header 'X-VO-Api-Id: _' \
      # --header 'X-VO-Api-Key: _' \
      # -d '{"userName": "_", "incidentNames": ["2170"], "message": "Testing"}' \
      # 'https://api.victorops.com/api-public/v1/incidents/ack'

      def run_command
        http = Net::HTTP.new API, PORT
        http.use_ssl = true

        resp = http.patch(PATH, body.to_json, headers)
        if resp.code.to_i == 200
          response.content = "Acked #{ENV['COG_ARGV_0']} by #{ENV['COG_USERNAME']}"
          response.content += " with '#{message}'" if message.to_s.length.positive?
        else
          response.content = "Failed to ack #{ENV['COG_ARGV_0']}: \`#{resp.body}\`"
        end

      end

      def message
        (1...ENV['COG_ARGC'].to_i)
          .map { |index| ENV["COG_ARGV_#{index}"] }
          .join(' ')
      end

      def body
        {
          userName: ENV['COG_USERNAME'],
          incidentNames: [ENV['COG_ARGV_0']],
          message: message
        }
      end

      def headers
        {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'X-VO-Api-Id' => ENV['VICTOROPS_API_ID'],
          'X-VO-Api-Key' => ENV['VICTOROPS_API_KEY']
        }
      end
    end
  end
end
