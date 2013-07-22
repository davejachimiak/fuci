require 'minitest/spec/expect'
require 'mocha/setup'
require_relative '../../../lib/fuci/runner'

describe Fuci::Runner do
  describe '.run' do
    before do
      Fuci::Runner.expects :ensure_server
      Fuci::Runner.expects :mount_default_testers
      Fuci::Runner.expects :fetch_log
      Fuci::Runner.expects :detect_tester_failure
      Fuci::Runner.expects :collect_failures
      Fuci::Runner.expects :run_failures
    end

    it 'ensures a server is present, ' +
      'mounts the default testers, ' +
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
        expect { Fuci::Runner.send :ensure_server }.to_raise Fuci::ServerError
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

  describe '.mount_default_testers' do
    it 'mounts the default tester gems' do
      testers = [:an_teacher, :parend, :loop]
      Fuci::Runner.stubs(:default_testers).returns testers
      Fuci::Runner.send :mount_default_testers

      expect(Fuci::Runner.testers).to_equal [:an_teacher, :parend, :loop]
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

  describe '.collect_failures' do
    it 'collects failures from the log with the detected tester' do
      detected_tester = mock
      Fuci::Runner.stubs(:log).returns log = mock
      detected_tester.
        stubs(:collect_failures).
        with(log).
        returns failures = mock
      Fuci::Runner.stubs(:detected_tester).returns detected_tester

      Fuci::Runner.send :collect_failures

      expect(Fuci::Runner.send :failures ).to_equal failures
    end
  end

  describe '.run_failures' do
    it 'runs the failrues locally' do
      detected_tester, failures = mock, mock
      Fuci::Runner.stubs(:detected_tester).returns detected_tester
      Fuci::Runner.stubs(:failures).returns failures
      detected_tester.expects(:run_failures).with failures

      Fuci::Runner.send :run_failures
    end
  end
end
