#!/usr/bin/env ruby

require 'cog/command'
module CogCmd
  module VictorOps
    class OnCall < Cog::Command
      def run_command
        response.content = 'Dave Long'
      end
    end

    # pay no attention to the man behind the curtain (@imbriaco)
    class Oncall < OnCall; end
  end
end
