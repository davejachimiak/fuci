require_relative '../../spec_helper'
require_relative '../../../lib/fuci/git'

class TestClass
  include Fuci::Git
end

describe Fuci::Git do
  before { @test_class = TestClass.new }

  describe '#current_branch_name' do
    it 'returns the current branch' do
      @test_class.stubs(:current_branch_command).
        returns current_branch_command = mock
      @test_class.expects(:with_popen).with current_branch_command

      @test_class.current_branch_name
    end
  end

  describe '#remote_repo_name' do
    it 'returns the remote repo name' do
      @test_class.stubs(:remote_repo_command).
        returns remote_repo_command = mock
      @test_class.expects(:with_popen).with remote_repo_command

      @test_class.remote_repo_name
    end
  end

  describe '#remote_master_sha' do
    it 'returns the remote master sha' do
      @test_class.stubs(:remote_sha_from_branch_command).
        with('master').
        returns command = mock
      @test_class.expects(:with_popen).with command

      @test_class.remote_master_sha
    end
  end

  describe '#remote_sha_from' do
    it 'returns the remote sha from the branch name passed in' do
      @test_class.stubs(:remote_sha_from_branch_command).
        with(branch_name = 'branch_name').
        returns command = mock
      @test_class.expects(:with_popen).with command

      @test_class.remote_sha_from branch_name
    end
  end

  describe '#pull_merge_sha_from' do
    it 'gets the merge sha from the pull number' do
      @test_class.stubs(:pull_number_from).
        with(branch_name = 'branch_name').
        returns pull_number = 1
      @test_class.stubs(:pull_merge_sha_command).
        with(pull_number).
        returns command = mock
      @test_class.stubs(:with_popen).
        with(command).
        returns sha = 'didizxndfjii223994w'

      expect(@test_class.pull_merge_sha_from(branch_name)).to_equal sha
    end
  end

  describe '#pull_number_from' do
    before do
      @branch_name = 'branch_name'
      command     = mock
      remote_sha  = '12k3asdifi23ia92'
      @test_class.stubs(:remote_sha_from).
        with(@branch_name).
        returns remote_sha
      @test_class.stubs(:pull_number_from_sha_command).
        with(remote_sha).
        returns command
      @with_popen = @test_class.stubs(:with_popen).with command
    end

    describe 'when there is a pull number' do
      before { @with_popen.returns @pull_number = '1' }

      it 'returns the pull number with the remote sha' do
        expect(@test_class.pull_number_from(@branch_name)).
          to_equal @pull_number
      end
    end

    describe 'when there is no pull number' do
      before { @with_popen.raises Fuci::Git::NoResponseError }

      it 'raises a NoPullError' do
        expect { @test_class.pull_number_from(@branch_name) }.
          to_raise Fuci::Git::NoPullError
      end
    end
  end

  describe '#with_popen' do
    describe 'when there is a string response' do
      it 'runs the command with popen' do
        current_branch = 'current_branch'
        result         = @test_class.send :with_popen, "echo #{current_branch}"

        expect(result).to_equal current_branch
      end
    end

    describe 'when the response is nil' do
      it 'raises a no response error' do
        IO.stubs(:popen).with(command = '').yields []

        expect { @test_class.send :with_popen, command }.to_raise Fuci::Git::NoResponseError
      end
    end
  end

  describe '#current_branch_command' do
    it 'returns the git/unix command to returnt the current branch' do
      current_branch_command = @test_class.send :current_branch_command
      expect(current_branch_command).to_equal "git branch | sed -n '/\* /s///p'"
    end
  end

  describe '#remote_repo_command' do
    it 'returns the git/unix command to return the remote owner/repo' do
      command = "git remote show -n origin | grep Push | cut -d/ -f4- | sed 's/\.git//g'"
      expect(@test_class.send :remote_repo_command).to_equal command
    end
  end

  describe '#remote_sha_from_branch_command' do
    it 'returns the git/unix command to return the remote sha from the branch' do
      branch_name = 'branch_name'
      command = @test_class.send :remote_sha_from_branch_command, branch_name
      expect(command).to_equal "git rev-parse origin/#{branch_name}"
    end
  end

  describe '#pull_merge_sha_command' do
    it 'is the pull merge sha command with the pull number' do
      pull_number = 1
      command     = @test_class.send :pull_merge_sha_command, pull_number
      expect(command).to_equal "git ls-remote origin | grep refs\\/pull\\/#{pull_number}\\/merge | awk '{ print $1 };'"
    end
  end

  describe '#pull_number_from_sha_command' do
    it 'gets the pull number with the sha' do
      sha     = '234asdf'
      command = @test_class.send :pull_number_from_sha_command, sha
      expect(command).to_equal "git ls-remote origin | grep #{sha} | grep pull | perl -n -e '/pull\\/(.*)\\/head/ && print $1'"
    end
  end
end
