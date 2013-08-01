module Fuci
  class CommandCache
    CACHE_FILE_LOCATION = '/tmp/last_fuci_command'

    def initialize command=nil
      @command = command
    end

    def cache_command
      file = File.new CACHE_FILE_LOCATION, 'w+'
      file.write @command
      file.close
    end

    def fetch
      File.read CACHE_FILE_LOCATION
    end
  end
end
