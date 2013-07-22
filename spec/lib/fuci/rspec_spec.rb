require_relative '../../spec_helper'
stub_class 'Fuci::Tester'
require_relative '../../../lib/fuci/rspec'

describe Fuci::RSpec do
  describe 'composition' do
    it 'inherits from Fuci::Tester' do
      expect(Fuci::RSpec.new).to_be_kind_of Fuci::Tester
    end
  end
end
