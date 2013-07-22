module Fuci
  class << self
    attr_accessor :server
  end

  def self.run
    ensure_server
    ensure_tester
    fetch_log
  end

  private

  def self.ensure_server
    raise Fuci::ServerError, 'A server must be attached to Fuci' unless server
  end

  def self.ensure_tester
  end

  def self.fetch_log
    @log = server.fetch_log
  end
end

class Fuci::ServerError < StandardError; end;
