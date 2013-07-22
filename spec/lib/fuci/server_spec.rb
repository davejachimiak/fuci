require_relative '../../spec_helper'
require_relative '../../../lib/fuci/server'

describe Fuci::Server do
  describe '#fetch_log' do
    it 'raises a NotImplemented error' do
      server = Fuci::Server.new
      expect { server.fetch_log }.to_raise NotImplementedError
    end
  end
end
