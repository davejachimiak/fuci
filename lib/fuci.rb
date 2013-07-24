require 'fuci/runner'
require 'fuci/rspec'
require 'fuci/configurable'

module Fuci
  include Configurable

  DEFAULT_TESTERS = [Fuci::RSpec]

  class << self
    attr_accessor :server, :options
  end

  def self.run
    Fuci::Runner.new.run
  end

  def self.add_testers *testers
    @testers += testers.flatten
  end

  def self.testers
    @testers ||= default_testers
  end

  def self.default_testers
    DEFAULT_TESTERS
  end

  def self.initialize_server!
    self.server = initialize_server
  end

  def self.initialize_testers!
    @testers = initialize_testers
  end

  private

  def self.initialize_server
    server.new
  end

  def self.initialize_testers
    testers.map { |tester| tester.new }
  end
end
