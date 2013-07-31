require_relative '../../spec_helper'
require_relative '../../../lib/fuci/runner'

stub_class 'IO'
stub_class 'Fuci::CommandCache'

describe Fuci::Runner do
  before { @runner = Fuci::Runner.new }

  describe '.run' do
    before do
      @runner.expects :initialize_server!
      @runner.expects :initialize_testers!
      @runner.expects :check_build
      @runner.expects :fetch_log
      @runner.expects :detect_tester_failure
      @runner.expects :cache_tester_command
      @runner.expects :run_failures
    end

    it 'initializes the testers, ' +
      'initializes the server, ' +
      'checks the build, ' +
      'fetches the log, ' +
      'detects which tester has the failure, ' +
      'caches the tester command, ' +
      'and runs the failures.' do
      @runner.run
    end
  end

  describe '.initialize_server' do
    it 'initializes the server' do
      Fuci.expects :initialize_server!
      @runner.send :initialize_server!
    end
  end

  describe '.initialize_testers' do
    it 'initializes the testers' do
      Fuci.expects :initialize_testers!
      @runner.send :initialize_testers!
    end
  end

  describe '.fetch_log' do
    it 'logs fetching; sets the log with delegation to the server' do
      @runner.expects(:puts).with "Fetching log from build..."
      @runner.stubs(:server).returns server = mock
      server.stubs(:fetch_log).returns log = mock

      @runner.send :fetch_log

      expect(@runner.send :log ).to_equal log
    end
  end

  describe '.detect_tester_failure' do
    describe 'a failure is detected by a tester plugin' do
      it 'detects the first tester failure in the log' do
        rspec, konacha, cucumber = mock, mock, mock
        @runner.stubs(:log).returns log = mock
        [rspec, cucumber].each { |t| t.stubs :indicates_failure? }
        konacha.stubs(:indicates_failure?).with(log).returns true
        konacha.class.stubs(:name).returns 'Fuci::Konacha'
        testers = [rspec, konacha, cucumber]
        @runner.expects(:puts).with 'Failure detected: Konacha'
        @runner.stubs(:testers).returns testers

        @runner.send :detect_tester_failure

        expect(@runner.send :detected_tester ).to_equal konacha
      end
    end

    describe 'if there was no detected tester' do
      it 'logs that no failure was detected by any tester plugin' do
        @runner.stubs(:testers).returns []
        @runner.expects(:puts_with_exit).
          with 'No failure was detected by any tester plugins.'

        @runner.send :detect_tester_failure
      end
    end
  end

  describe '#cache_tester_command' do
    it 'calls #cache on CommandCache' do
      @runner.stubs(:log).returns log = mock
      @runner.stubs(:detected_tester).returns tester = mock
      tester.stubs(:command).with(log).returns command = mock
      Fuci::CommandCache.stubs(:new).
        with(command).
        returns cache = mock
      cache.expects :cache_command

      @runner.send :cache_tester_command
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

  describe '.check_build' do
    describe 'status is green' do
      before { @runner.stubs(:build_status).returns :green }

      it 'prints a message that the lastest build passed and exits' do
        @runner.expects(:puts).with 'Build is green.'
        @runner.expects :exit
        @runner.send :check_build
      end
    end

    describe 'status is yellow' do
      before { @runner.stubs(:build_status).returns :yellow }

      it 'prints a message that the build in question passed is bad and exits' do
        @runner.expects(:puts).with 'Build has errored. Check build for more info.'
        @runner.expects :exit
        @runner.send :check_build
      end
    end

    describe 'status is red' do
      before { @runner.stubs(:build_status).returns :red }

      it 'returns nil' do
        expect(@runner.send :check_build ).to_be_nil
      end
    end
  end
end
