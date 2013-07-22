module Fuci
  class RSpec < Fuci::Tester
    FAILURE_INDICATOR = 'Failed examples:'
    BASE_COMMAND      = 'rspec'

    def indicates_failure? log
      log.include? FAILURE_INDICATOR
    end

    def command log
      "#{base_command} #{failures log }"
    end

    private

    def base_command
      BASE_COMMAND
    end

    def failures log
      log.scan(/rspec (.*) #/).join ' '
    end
  end
end
