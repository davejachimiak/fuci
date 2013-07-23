require 'forwardable'

module Fuci
  class Runner
    extend Forwardable

    def_delegators :Fuci, :server, :testers, :initialize_server!,
                   :initialize_testers!
    attr_accessor  :log, :detected_tester, :failures

    def run
      initialize_server!
      initialize_testers!
      fetch_log
      detect_tester_failure
      run_failures
    end

    private

    def fetch_log
      self.log = server.fetch_log
    end

    def detect_tester_failure
      self.detected_tester = testers.detect do |tester|
        tester.indicates_failure? log
      end
    end

    def run_failures
      IO.popen detected_tester.command(log) do |io|
        io.each { |string| puts string }
      end
    end

    class ServerError < StandardError; end;
  end
end
