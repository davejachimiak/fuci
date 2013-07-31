require_relative '../../spec_helper'
require_relative '../../../lib/fuci/cached_command_runner'

stub_class 'IO'
stub_class 'Fuci::CommandCache'

describe Fuci::CachedCommandRunner do
  before { @runner = Fuci::CachedCommandRunner.new }

  describe '#run' do
    it 'runs the command cached' do
      @runner.expects(:puts).with 'Running specs from last call to fuci.'
      @runner.stubs(:cached_command).returns command = mock
      IO.expects(:popen).with command

      @runner.run
    end
  end

  describe '#cached_command' do
    it 'delegates to command cache' do
      @runner.stubs(:command_cache).returns command_cache = mock
      command_cache.stubs(:fetch).returns cached_command = 'command'

      expect(@runner.cached_command).to_equal cached_command
    end
  end

  describe '#command_cache' do
    it 'caches and command cache object' do
      Fuci::CommandCache.stubs(:new).returns command_cache = mock
      expect(@runner.command_cache).to_equal command_cache
    end
  end
end
