require_relative '../../spec_helper'
require_relative '../../../lib/fuci/runner'

stub_class 'IO'

describe Fuci::Runner do
  before { @runner = Fuci::Runner.new }

  describe '.run' do
    before do
      @runner.expects :initialize_testers!
      @runner.expects :initialize_server!
      @runner.expects :fetch_log
      @runner.expects :detect_tester_failure
      @runner.expects :run_failures
    end

    it 'initializes the testers, ' +
      'initializes the server, ' +
      'fetches the log, ' +
      'detects which tester has the failure, ' +
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
