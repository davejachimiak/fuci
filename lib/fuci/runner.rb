require 'forwardable'

module Fuci
  class Runner
    extend Forwardable

    def_delegators :Fuci, :server, :testers

    class << self
      attr_accessor :log, :detected_tester, :failures
    end

    def self.run
      ensure_server
      fetch_log
      detect_tester_failure
      collect_failures
      run_failures
    end

    private

    def self.ensure_server
      unless server
        raise Fuci::Runner::ServerError, 'A server must be declared in Fuci config.'
      end
    end

    def self.fetch_log
      self.log = server.fetch_log
    end

    def self.detect_tester_failure
      self.detected_tester = testers.detect do |tester|
        tester.indicates_failure? log
      end
    end

    def self.collect_failures
      self.failures = detected_tester.collect_failures log
    end

    def self.run_failures
      detected_tester.run_failures failures
    end

    class ServerError < StandardError; end;
  end
end
