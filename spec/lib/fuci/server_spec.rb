require_relative '../../spec_helper'
require_relative '../../../lib/fuci/server'

describe Fuci::Server do
  describe '#fetch_log' do
    it 'raises a NotImplemented error' do
      server = Fuci::Server.new
      expect { server.fetch_log }.to_raise NotImplementedError
    end
  end

  describe '#remove_ascii_color_chars' do
    it 'removes the ascii color characters' do
      server       = Fuci::Server.new
      string       = "\e[33mbody"
      clean_string = 'body'

      processed_string = server.send :remove_ascii_color_chars, string

      expect(processed_string).to_equal clean_string
    end
  end
end
