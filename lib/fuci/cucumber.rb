require 'fuci/tester'

module Fuci
  class Cucumber < Tester
    FAILURE_INDICATOR = 'Failing Scenarios:'
    BASE_COMMAND      = 'cucumber --color'
    FAIL_FILE_CAPTURE = /cucumber (.*) #/

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
