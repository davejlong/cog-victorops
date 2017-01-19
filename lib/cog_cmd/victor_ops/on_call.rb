#!/usr/bin/env ruby

require 'cog/command'
module CogCmd
  module VictorOps
    class OnCall < Cog::Command
      def run_command
        response.content = 'Dave Long'
      end
    end
  end
end
