require 'fuci/runner'
require 'fuci/rspec'

module Fuci
  DEFAULT_TESTERS = [Fuci::RSpec]

  class << self
    attr_accessor :server
  end

  def self.run
    Fuci::Runner.new.run
  end

  def self.configure
    yield self
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

  def self.initialize_testers
    @testers = testers.map { |tester| tester.new }
  end
end
