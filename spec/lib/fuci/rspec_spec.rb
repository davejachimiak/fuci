require_relative '../../spec_helper'
stub_class 'Fuci::Tester'
require_relative '../../../lib/fuci/rspec'

describe Fuci::RSpec do
  describe 'composition' do
    it 'inherits from Fuci::Tester' do
      expect(Fuci::RSpec.new).to_be_kind_of Fuci::Tester
    end
  end

  describe '#indicates_failure?' do
    describe 'when the log passed in has "Failed examples: "' do
      it 'returns true' do
        rspec = Fuci::RSpec.new
        log   = "irjioerijoijoaf;joia;ijoawfeFailed examples: "

        expect(rspec.indicates_failure?(log)).to_equal true
      end
    end

    describe 'when the log passed in has no "Failed examples: "' do
      it 'returns false'
    end
  end
end
