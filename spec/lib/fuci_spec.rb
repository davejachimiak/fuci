require_relative '../spec_helper'
require_relative '../../lib/fuci'

stub_class 'Fuci::Runner'

describe Fuci do
  describe '.run' do
    it 'calls #run on an instnace on runner' do
      Fuci::Runner.stubs(:new).returns runner = mock
      runner.expects :run

      Fuci.run
    end
  end
end
