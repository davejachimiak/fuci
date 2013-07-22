require_relative '../../spec_helper'
require_relative '../../../lib/fuci/tester'

describe Fuci::Tester do
  before { @tester = Fuci::Tester.new }

  describe '#indicates_failure?' do
    it 'raises a NotImplemented error' do
      expect { @tester.indicates_failure? '' }.to_raise NotImplementedError
    end
  end

  describe '#command' do
    it 'raises a NotImplemented error' do
      expect { @tester.command '' }.to_raise NotImplementedError
    end
  end
end
