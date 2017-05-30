#!/usr/bin/env ruby

require 'cog/command'
require 'json'

require_relative 'helpers'

module CogCmd
  module VictorOps
    class Incidents < Cog::Command
      include Helpers

      PATH = "#{BASE_PATH}/incidents".freeze
      TEMPLATE = 'incidents'.freeze
      DEFAULT_PHASES = 'acked,unacked'.freeze

      def run_command
        resp = http_client.get(PATH, headers)
        if resp.code.to_i == 200
          response.content = parse_body(resp.body)
          response.template = TEMPLATE
        else
          response.content = "Failed to get incidents: \`#{resp.body}\`"
        end
        response
      end

      def parse_body(body)
        phases = if ENV['COG_OPT_PHASE'].to_s.length.positive?
          ENV['COG_OPT_PHASE']
        else
          DEFAULT_PHASES
        end.split(',')

        body = JSON.parse body
        body['incidents'].map do |incident|
          {
            id: incident['incidentNumber'],
            phase: incident['currentPhase'],
            message: message_for(incident)
          }
        end.select do |incident|
          phases.any? do |phase|
            phase.strip.upcase == incident[:phase]
          end
        end
      end

      def message_for(incident)
        if incident['entityDisplayName'].length.positive?
          incident['entityDisplayName']
        else
          incident['entityId']
        end
      end
    end
  end
end
