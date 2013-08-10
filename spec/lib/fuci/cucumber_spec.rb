require_relative '../../spec_helper'
require_relative '../../../lib/fuci/cucumber'

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

  describe '#command' do
    it 'returns "cucumber <failure string>"' do
      log = """
        cucumber is #ljasdfois\ncucumber ok #jcicisj\ncucumber for #ie
        iejfasdi\ncucumber testing #iiiirrpepwpqapc
      """

      command = @cucumber.command log

      expect(command).to_equal 'cucumber is ok for testing'
    end
  end
end
