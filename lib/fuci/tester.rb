module Fuci
  class Tester

    # must return a boolean telling whether the
    # log passed in indicates a failure made by
    # the tester
    def indicates_failure? log
      raise NotImplementedError
    end

    # must return a command string to be executed
    # by the system, e.g.
    # "rspec ./spec/features/it_is_cool_spec.rb"
    def command log
      raise NotImplementedError
    end
  end
end
