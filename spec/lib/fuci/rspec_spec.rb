require_relative '../../spec_helper'
stub_class 'Fuci::Tester'
require_relative '../../../lib/fuci/rspec'

describe Fuci::RSpec do
  before { @rspec = Fuci::RSpec.new }
  describe 'composition' do
    it 'inherits from Fuci::Tester' do
      expect(@rspec).to_be_kind_of Fuci::Tester
    end
  end

  describe '#indicates_failure?' do
    describe 'when the log passed in has "Failed examples:"' do
      before { @log = "irjioerijoijoaf;joia;ijoawfeFailed examples:" }

      it 'returns true' do
        expect(@rspec.indicates_failure?(@log)).to_equal true
      end
    end

    describe 'when the log passed in has no "Failed examples:"' do
      before { @log = "irjioerijoijpoop: " }

      it 'returns false' do
        expect(@rspec.indicates_failure?(@log)).to_equal false
      end
    end
  end
end
