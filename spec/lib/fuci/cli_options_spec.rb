require_relative '../../spec_helper'
require_relative '../../../lib/fuci/cli_options'

describe Fuci::CliOptions do
  describe '.run_last_command?' do
    before { @argv = Fuci::CliOptions.stubs(:argv) }

    describe 'when argv contains --last' do
      before { @argv.returns ['--last'] }

      it 'returns true' do
        expect(Fuci::CliOptions.run_last_command?).to_equal true
      end
    end

    describe 'when argv contains -l' do
      before { @argv.returns ['-l'] }

      it 'returns true' do
        expect(Fuci::CliOptions.run_last_command?).to_equal true
      end
    end

    describe 'when argv contains neither of the above' do
      before { @argv.returns [] }

      it 'returns true' do
        expect(Fuci::CliOptions.run_last_command?).to_equal false
      end
    end
  end
end
