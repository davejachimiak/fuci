module Fuci
  class Runner
    DEFAULT_TESTERS = []

    class << self
      attr_accessor :server
      attr_writer :testers
      private
      attr_accessor :log, :detected_tester, :failures
    end

    def self.run
      ensure_server
      mount_default_testers
      fetch_log
      detect_tester_failure
      collect_failures
      run_failures
    end

    private

    def self.ensure_server
      raise Fuci::ServerError, 'A server must be attached to Fuci.' unless server
    end

    def self.mount_default_testers
      self.testers += default_testers
    end

    def self.testers
      @testers ||= []
    end

    def self.default_testers
      DEFAULT_TESTERS
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
  end

  class ServerError < StandardError; end;
end
