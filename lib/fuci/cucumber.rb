require 'fuci/tester'

module Fuci
  class Cucumber < Tester
  end
end

require_relative '../../spec/spec_helper'

describe Fuci::Cucumber do
  describe 'composition' do
    it 'inherits from Tester' do
      cucumber = Fuci::Cucumber.new
      expect(cucumber).to_be_kind_of Fuci::Tester
    end
  end
end
