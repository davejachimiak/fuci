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

    def self.run_failures
      IO.popen detected_tester.command do |io|
        io.each { |string| puts string }
      end
    end

    class ServerError < StandardError; end;
  end
end
