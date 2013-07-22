module Fuci
  class << self
    attr_accessor :server
    attr_reader :testers
  end

  def self.run
    ensure_server
    mount_default_testers
    fetch_log
    detect_tester_failure_in_log
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
    @log = server.fetch_log
  end

  def self.default_testers
    []
  end

  def self.detect_tester_failure_in_log
  end
end

class Fuci::ServerError < StandardError; end;
