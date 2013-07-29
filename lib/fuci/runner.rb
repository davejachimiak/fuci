require 'forwardable'

module Fuci
  class Runner
    extend Forwardable

    def_delegators :Fuci, :server, :testers, :initialize_server!,
                   :initialize_testers!
    def_delegator  :server, :build_status
    attr_accessor  :log, :detected_tester, :failures

    def run
      initialize_server!
      initialize_testers!
      check_build
      fetch_log
      detect_tester_failure
      run_failures
    end

    private

    def check_build
      case build_status
      when :green
        puts_with_exit 'Build is green.'
      when :yellow
        puts_with_exit 'Build has errored. Check build for more info.'
      end
    end

    def fetch_log
      puts "Fetching log from build..."
      self.log = server.fetch_log
    end

    def detect_tester_failure
      self.detected_tester = testers.detect do |tester|
        tester.indicates_failure? log
      end
      puts "Failure detected: #{detected_tester.class.name.split('::').last}"
    end

    def run_failures
      IO.popen detected_tester.command(log) do |io|
        puts 'Running failed specs...'
        io.each { |string| puts string }
      end
    end

    def puts_with_exit string
      puts string
      exit
    end
  end
end
