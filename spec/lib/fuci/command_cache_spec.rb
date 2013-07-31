require_relative '../../spec_helper'
require_relative '../../../lib/fuci/command_cache'

stub_class 'File'

describe Fuci::CommandCache do
  before do
    @command       = 'command'
    @command_cache = Fuci::CommandCache.new @command
  end

  describe '#cache_command' do
    it 'writes the command to last_fuci_command file' do
      File.stubs(:new).with('/tmp/last_fuci_command', 'w+').
        returns file = mock
      file.expects(:write).with @command
      file.expects :close

      @command_cache.cache_command
    end
  end

  describe '#fetch' do
    it 'fetches the cached command' do
      cached_command = 'cached command'
      File.stubs(:read).
        with('/tmp/last_fuci_command').
        returns cached_command

      expect(@command_cache.fetch).to_equal cached_command
    end
  end
end
