require 'minitest/spec/expect'
require 'mocha'
require_relative '../../lib/fuci'

describe Fuci do
  describe '#run' do
    before do
      @server     = mock
      Fuci.server = @server

      @server.expects :fetch_log
    end

    it 'ensures a server is present' do
      Fuci.expects :ensure_server
      Fuci.run
    end

    it 'grabs the log from the server' do
      Fuci.run
    end

    it 'plugs in the test frameworks'
    it 'detects the first framework in the log that has a failure'
    it 'parses the log for and collects failures'
    it 'runs those failures locally'
  end

  describe '#ensure_server' do
    before { Fuci.stubs(:server).returns :AnServer }

    describe 'when a server is attached to the module' do
      it 'is a no-op' do
        expect(Fuci.send :ensure_server ).to_equal nil
      end
    end

    describe 'when a server is not attached' do
      before { Fuci.stubs(:server).returns nil }

      it 'raises an error with an appropriate message' do
        expect { Fuci.send :ensure_server }.to_raise Fuci::ServerError
      end
    end
  end
end
