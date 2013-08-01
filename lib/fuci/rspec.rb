require 'fuci/tester'

module Fuci
  class RSpec < Fuci::Tester
    FAILURE_INDICATOR = 'Failed examples:'
    BASE_COMMAND      = 'rspec --tty'
    FAIL_FILE_CAPTURE = /rspec (.*) #/

    def indicates_failure? log
      log.include? FAILURE_INDICATOR
    end

    def command log
      @command ||= "#{base_command} #{failures log }"
    end

    private

    def base_command
      BASE_COMMAND
    end

    def failures log
      log.scan(FAIL_FILE_CAPTURE).join ' '
    end
  end
end
