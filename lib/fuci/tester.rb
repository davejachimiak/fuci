module Fuci
  class Tester

    # must return a boolean telling whether the
    # log passed in indicates a failure made by
    # the tester
    def indicates_failure? log
      raise NotImplementedError
    end
  end
end
