require_relative '../../spec_helper'
require_relative '../../../lib/fuci/configurable'

describe Fuci::Configurable do
  describe '.configure' do
    it 'yields the block to self' do
      test_string = 'configuring!'

      Fuci::Configurable.expects(:puts).with test_string

      Fuci::Configurable.configure do |f|
        f.send :puts, test_string
      end
    end
  end
end
