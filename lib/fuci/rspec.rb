module Fuci
  class RSpec < Fuci::Tester
    def indicates_failure? log
      true
    end
  end
end
