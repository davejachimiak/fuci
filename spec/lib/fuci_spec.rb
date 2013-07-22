require 'mocha'
require 'minitest/spec/expect'
require_relative '../../lib/fuci'

describe Fuci do
  describe '#run' do
    it 'ensures a server is present' do
      Fuci.expects :ensure_server

      Fuci.run
    end

    it 'grabs the log from the server'
    it 'plugs in the test frameworks'
    it 'detects the first framework in the log that has a failure'
    it 'parses the log for and collects failures'
    it 'runs those failures locally'
  end
end
