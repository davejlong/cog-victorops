#!/usr/bin/env ruby

require 'cog/command'
require 'json'

require_relative 'helpers'

module CogCmd
  module VictorOps
    class Ack < Cog::Command
      include Helpers
      PATH = "#{BASE_PATH}/incidents/ack".freeze

      def run_command
        resp = http_client.patch(PATH, body.to_json, headers)
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
    end
  end
end
