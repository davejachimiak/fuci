require_relative '../../spec_helper'
require_relative '../../../lib/fuci/runner'

stub_class 'IO'

describe Fuci::Runner do
  before { @runner = Fuci::Runner.new }

  describe '.run' do
    before do
      @runner.expects :ensure_server
      @runner.expects :initialize_testers
      @runner.expects :fetch_log
      @runner.expects :detect_tester_failure
      @runner.expects :run_failures
    end

    it 'ensures a server is present, ' +
      'fetches the log from the server, ' +
      'detects which tester has the failure, ' +
      "collects the tester's failure from the log, " +
      'an runs the failures.' do
      @runner.run
    end
  end

  describe '.ensure_server' do
    before { @runner.stubs(:server).returns :AnServer }

    describe 'when a server is attached to the module' do
      it 'is a no-op' do
        expect(@runner.send :ensure_server ).to_equal nil
      end
    end

    describe 'when a server is not attached' do
      before { @runner.stubs(:server).returns nil }

      it 'raises an error with an appropriate message' do
        expect { @runner.send :ensure_server }.
          to_raise Fuci::Runner::ServerError
      end
    end
  end

  describe '.initialize_testers' do
    it 'initializes the testers' do
      Fuci.expects(:initialize_testers)
      @runner.send :initialize_testers
    end
  end

  describe '.fetch_log' do
    it 'delegates to the server' do
      @runner.stubs(:server).returns poop = mock
      poop.stubs(:fetch_log).returns log = mock
      @runner.send :fetch_log

      expect(@runner.send :log ).to_equal log
    end
  end

  describe '.detect_tester_failure' do
    it 'detects the first tester failure in the log' do
      rspec, konacha, cucumber = mock, mock, mock
      @runner.stubs(:log).returns log = mock
      [rspec, cucumber].each { |t| t.stubs :indicates_failure? }
      konacha.stubs(:indicates_failure?).with(log).returns true
      testers = [rspec, konacha, cucumber]
      @runner.stubs(:testers).returns testers

      @runner.send :detect_tester_failure

      expect(@runner.send :detected_tester ).to_equal konacha
    end
  end

  describe '.run_failures' do
    it 'runs the failrues locally' do
      @runner.stubs(:detected_tester).returns detected_tester = mock
      @runner.stubs(:log).returns log = mock
      detected_tester.
        stubs(:command).
        with(log).
        returns command = mock
      IO.expects(:popen).with command

      @runner.send :run_failures
    end
  end
end
