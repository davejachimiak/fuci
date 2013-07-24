require_relative '../../spec_helper'
require_relative '../../../lib/fuci/configurable'

describe Fuci::Configurable do
  describe '.configure' do
    it 'yields the block to self' do
      module TestMod
        include Fuci::Configurable
      end

      test_string = 'configuring!'
      TestMod.expects(:puts).with test_string
      TestMod.configure do |f|
        f.send :puts, test_string
      end
    end
  end
end
