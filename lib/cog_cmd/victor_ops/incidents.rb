#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cog/command'
require 'json'

require_relative 'helpers'

module CogCmd
  module VictorOps
    ##
    ## Look up information about incidents
    ##
    class Incidents < Cog::Command
      include Helpers

      PATH = "#{BASE_PATH}/incidents"
      TEMPLATE = 'incidents'
      DEFAULT_PHASES = 'acked,unacked'

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
        JSON.parse(body)['incidents']
          .map { |incident| format_incident(incident) }
          .select do |incident|
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

      def format_incident(incident)
        {
          id: incident['incidentNumber'],
          phase: incident['currentPhase'],
          message: message_for(incident)
        }
      end

      def phases
        if ENV['COG_OPT_PHASE'].to_s.length.positive?
          ENV['COG_OPT_PHASE']
        else
          DEFAULT_PHASES
        end.split(',')
      end
    end
  end
end
