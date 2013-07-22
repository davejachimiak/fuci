module Fuci
  class << self
    attr_accessor :server, :log, :detected_tester
    attr_reader :testers
  end

  def self.run
    ensure_server
    mount_default_testers
    fetch_log
    detect_tester_failure_in_log
    collect_failures
  end

  private

  def self.ensure_server
    raise Fuci::ServerError, 'A server must be attached to Fuci' unless server
  end

  def self.mount_default_testers
    @testers ||= []
    @testers += default_testers
  end

  def self.fetch_log
    self.log = server.fetch_log
  end

  def self.default_testers
    []
  end

  def self.detect_tester_failure_in_log
    self.detected_tester = testers.detect do |tester|
      tester.indicates_failure? log
    end
  end

  def self.collect_failures
  end
end

class Fuci::ServerError < StandardError; end;
