require_relative '../spec_helper'
require_relative '../../lib/fuci'

stub_class 'Fuci::Runner'

describe Fuci do
  describe '.run' do
    it 'calls #run on an instnace on runner' do
      Fuci::Runner.stubs(:new).returns runner = mock
      runner.expects :run

      Fuci.run
    end
  end

  describe '.server/=' do
    it 'is an accessor' do
      expect(Fuci.server).to_be_nil
      Fuci.server = server = mock
      expect(Fuci.server).to_equal server
      Fuci.server = nil
    end
  end

  describe '.testers' do
    it 'is an array accessor' do
      expect(Fuci.testers).to_be_instance_of Array
    end
  end

  describe '.add_testers' do
    before { @rspec, @konacha = mock, mock }
    after  { Fuci.instance_variable_set :@testers, [] }

    describe 'when one to many args are passed in' do
      it 'adds the args to testers' do
        Fuci.add_testers @rspec, @konacha

        testers = Fuci.testers
        expect(testers).to_equal [@rspec, @konacha]
      end
    end

    describe 'when an array is passed in' do
      it 'adds the args to testers' do
        Fuci.add_testers [@rspec, @konacha]

        testers = Fuci.testers
        expect(testers).to_equal [@rspec, @konacha]
      end
    end
  end

  describe '.configure' do
    it 'yields the block with self' do
      server = :server
      Fuci.configure do |f|
        f.server = server
      end

      expect(Fuci.server).to_equal server
      Fuci.server = nil
    end
  end
end
