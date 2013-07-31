require 'forwardable'
require 'fuci/command_cache'

module Fuci
  class CachedCommandRunner
    extend Forwardable

    def_delegator :command_cache, :fetch, :cached_command

    def run
      puts 'Running specs from last call to fuci.'

      IO.popen cached_command do |id|
        io.each { |string| puts string }
      end
    end

    def command_cache
      @command_cache ||= CommandCache.new
    end
  end
end
