#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cog/command'
require 'json'

require_relative 'helpers'

module CogCmd
  module VictorOps
    ##
    ## Ack an open incident.
    ##
    class Ack < Cog::Command
      include Helpers
      PATH = "#{BASE_PATH}/incidents/ack"

      def run_command
        resp = http_client.patch(PATH, body.to_json, headers)
        response.content = if resp.code.to_i == 200
          positive_response
        else
          negative_response
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
          incidentNames: [incident_id],
          message: message
        }
      end

      private

      def incident_id
        ENV['COG_ARGV_0']
      end

      def positive_response
        response = "Acked #{incident_id} by #{cog_username}"
        response += "with \`#{message}\`" if message.to_s.length.positive?
        response
      end

      def negative_response
        "Failed to ack #{incident_id}: \`#{resp.body}\`"
      end
    end
  end
end
