require_relative '../../spec_helper'
require_relative '../../../lib/fuci/runner'

stub_class 'IO'

describe Fuci::Runner do
  describe '.run' do
    before do
      Fuci::Runner.expects :ensure_server
      Fuci::Runner.expects :fetch_log
      Fuci::Runner.expects :detect_tester_failure
      Fuci::Runner.expects :run_failures
    end

    it 'ensures a server is present, ' +
      'fetches the log from the server, ' +
      'detects which tester has the failure, ' +
      "collects the tester's failure from the log, " +
      'an runs the failures.' do
      Fuci::Runner.run
    end
  end

  describe '.ensure_server' do
    before { Fuci::Runner.stubs(:server).returns :AnServer }

    describe 'when a server is attached to the module' do
      it 'is a no-op' do
        expect(Fuci::Runner.send :ensure_server ).to_equal nil
      end
    end

    describe 'when a server is not attached' do
      before { Fuci::Runner.stubs(:server).returns nil }

      it 'raises an error with an appropriate message' do
        expect { Fuci::Runner.send :ensure_server }.
          to_raise Fuci::Runner::ServerError
      end
    end
  end

  describe '.fetch_log' do
    it 'delegates to the server' do
      Fuci::Runner.stubs(:server).returns poop = mock
      poop.stubs(:fetch_log).returns log = mock
      Fuci::Runner.send :fetch_log

      expect(Fuci::Runner.send :log ).to_equal log
    end
  end

  describe '.detect_tester_failure' do
    it 'detects the first tester failure in the log' do
      rspec, konacha, cucumber = mock, mock, mock
      Fuci::Runner.stubs(:log).returns log = mock
      [rspec, cucumber].each { |t| t.stubs :indicates_failure? }
      konacha.stubs(:indicates_failure?).with(log).returns true
      testers = [rspec, konacha, cucumber]
      Fuci::Runner.stubs(:testers).returns testers

      Fuci::Runner.send :detect_tester_failure

      expect(Fuci::Runner.send :detected_tester ).to_equal konacha
    end
  end

  describe '.run_failures' do
    it 'runs the failrues locally' do
      Fuci::Runner.stubs(:detected_tester).returns detected_tester = mock
      detected_tester.stubs(:command).returns command = mock
      IO.expects(:popen).with command

      Fuci::Runner.send :run_failures
    end
  end
end
