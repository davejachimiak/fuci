require 'fuci/tester'

module Fuci
  class Cucumber < Tester
    FAILURE_INDICATOR = 'Failing Scenarios:'

    def indicates_failure? log
      log.include? FAILURE_INDICATOR
    end
  end
end

require_relative '../../spec/spec_helper'

describe Fuci::Cucumber do
  before { @cucumber = Fuci::Cucumber.new }

  describe 'composition' do
    it 'inherits from Tester' do
      expect(@cucumber).to_be_kind_of Fuci::Tester
    end
  end

  describe '#indicates_failure?' do
    describe "the log passed in includes 'Failing Scenarios:'" do
      before { @log = 'jdivzxdfiweafFailing Scenarios:jeidxl' }

      it 'returns true' do
        expect(@cucumber.indicates_failure? @log ).to_equal true
      end
    end

    describe "the log passed in doesn't include 'Failing Scenarios:'" do
      before { @log = 'jdivzxdfiweafFailed Examples:jeidxl' }

      it 'returns false' do
        expect(@cucumber.indicates_failure? @log ).to_equal false
      end
    end
  end
end
