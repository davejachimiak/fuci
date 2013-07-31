require_relative '../../spec_helper'
require_relative '../../../lib/fuci/cli_options'

describe Fuci::CliOptions do
  describe 'argv' do
    describe 'when there are options from the command line' do
      it 'returns those options' do
        argv_options = ['yup', 'yer']
        Fuci.stubs(:options).returns({ argv: argv_options })

        expect(Fuci::CliOptions.argv).to_equal argv_options
      end
    end

    describe 'when there are no options from the command line' do
      it 'returns those options' do
        Fuci.stubs(:options).returns({ argv: nil })

        expect(Fuci::CliOptions.argv).to_equal []
      end
    end
  end

  describe '.run_last_command?' do
    describe 'when argv contains --last' do
      before { Fuci::CliOptions.stubs(:argv).returns ['--last'] }

      it 'returns true' do
        expect(Fuci::CliOptions.run_last_command?).to_equal true
      end
    end

    describe 'when argv contains -l' do
      before { Fuci::CliOptions.stubs(:argv).returns ['-l'] }

      it 'returns true' do
        expect(Fuci::CliOptions.run_last_command?).to_equal true
      end
    end

    describe 'when argv contains neither of the above' do
      before { Fuci::CliOptions.stubs(:argv).returns [] }

      it 'returns true' do
        expect(Fuci::CliOptions.run_last_command?).to_equal false
      end
    end
  end
end
