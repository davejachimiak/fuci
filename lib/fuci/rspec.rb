module Fuci
  class RSpec < Fuci::Tester
    FAILURE_INDICATOR = 'Failed examples:'

    def indicates_failure? log
      log.include? FAILURE_INDICATOR
    end
  end
end
