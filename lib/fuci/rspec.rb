module Fuci
  class RSpec < Fuci::Tester
    FAILURE_INDICATOR = 'Failed examples:'

    def indicates_failure? log
      log.include? FAILURE_INDICATOR
    end

    def command log
      failures = log.scan(/rspec (.*) #/).join ' '
      "rspec #{failures}"
    end
  end
end
