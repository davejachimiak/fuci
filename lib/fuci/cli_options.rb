module Fuci
  class CliOptions
    RUN_LAST_COMMAND_FLAGS = ['--last', '-l']

    def self.run_last_command?
      (argv & RUN_LAST_COMMAND_FLAGS).any?
    end

    private

    def self.argv
      Fuci.options[:argv] || []
    end
  end
end
