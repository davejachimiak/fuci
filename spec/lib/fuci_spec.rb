require 'minitest/spec/expect'
require 'mocha/setup'
require_relative '../../lib/fuci'

describe Fuci do
  describe '.run' do
    before do
      @server     = mock
      Fuci.server = @server
      Fuci.stubs :collect_failures
      Fuci.expects :fetch_log
    end

    it 'ensures a server is present' do
      Fuci.expects :ensure_server
      Fuci.run
    end

    it 'mounts the default testers' do
      Fuci.stubs(:detect_tester_failure_in_log)
      Fuci.expects :mount_default_testers
      Fuci.run
    end

    it 'grabs the log from the server' do
      Fuci.run
    end

    it 'detects the first tester in the log that has a failure' do
      Fuci.expects :detect_tester_failure_in_log
      Fuci.run
    end

    it 'parses the log for and collects failures' do
      Fuci.expects :collect_failures
      Fuci.run
    end

    it 'runs those failures locally'
  end

  describe '.ensure_server' do
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

  describe '.fetch_log' do
    it 'delegates to the server' do
      Fuci.stubs(:server).returns poop = mock
      poop.stubs(:fetch_log).returns log = mock
      Fuci.send :fetch_log

      expect(Fuci.log).to_equal log
    end
  end

  describe '.mount_default_testers' do
    it 'mounts the default tester gems' do
      testers = [:an_teacher, :parend, :loop]
      Fuci.stubs(:default_testers).returns testers
      Fuci.send :mount_default_testers

      expect(Fuci.testers).to_equal [:an_teacher, :parend, :loop]
    end
  end

  describe '.detect_tester_failure_in_log' do
    it 'detects the first tester failure in the log' do
      rspec, konacha, cucumber = mock, mock, mock
      Fuci.log = log = mock
      [rspec, cucumber].each { |t| t.stubs :indicates_failure? }
      konacha.stubs(:indicates_failure?).with(log).returns true
      testers = [rspec, konacha, cucumber]
      Fuci.stubs(:testers).returns testers
      Fuci.send :detect_tester_failure_in_log

      expect(Fuci.detected_tester).to_equal konacha
    end
  end

  describe '.collect_failures' do
    it 'collects failures from the log with the detected tester' do
      detected_tester = mock
      Fuci.stubs(:log).returns log = mock
      detected_tester.
        stubs(:collect_failures).
        with(log).
        returns failures = mock
      Fuci.stubs(:detected_tester).returns detected_tester

      Fuci.send :collect_failures

      expect(Fuci.failures).to_equal failures
    end
  end
end
