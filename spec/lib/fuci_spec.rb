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
    before do
      @rspec, @konacha = mock, mock
      mocks = [@rspec, @konacha]
      mocks.each { |m| m.expects :to_ary }
    end
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

  describe '.initialize_testers' do
    it 'mutates the testers attribute to initialized testers' do
      class Cool; end;
      Fuci.instance_variable_set :@testers, [Cool]
      Cool.stubs(:new).returns cool = mock
      testers = [cool]

      Fuci.initialize_testers

      expect(Fuci.testers).to_equal testers
    end
  end
end
