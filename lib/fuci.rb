require 'fuci/runner'

module Fuci
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
    @testers ||= []
  end

  def self.initialize_testers
    @testers = testers.map { |tester| tester.new }
  end
end
