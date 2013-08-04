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
    before do
      @branch_name = 'branch_name'
      @command     = mock
      @test_class.stubs(:pull_merge_sha_command).
        with(@branch_name).
        returns @command
      @with_popen = @test_class.stubs(:with_popen).with @command
    end

    describe 'when there is a pull request' do
      it 'returns the merge sha from the pull request' do
        @with_popen.returns remote_sha = '19298fjnxnfjsdf84'
        expect(@test_class.pull_merge_sha_from(@branch_name)).
          to_equal remote_sha
      end
    end

    describe 'when there is no pull request' do
      it 'raises a NoPullError' do
        @with_popen.returns ''
        expect { @test_class.pull_merge_sha_from(@branch_name) }.
          to_raise Fuci::Git::NoPullError
      end
    end
  end

  describe '#with_popen' do
    it 'runs the command with popen' do
      current_branch = 'current_branch'
      result         = @test_class.send :with_popen, "echo #{current_branch}"

      expect(result).to_equal current_branch
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
      command = "git remote -v | grep origin | grep push | awk 'match($0, /:\(.*)\.git/) { print substr($0, RSTART+1, RLENGTH-5) }'"
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
end
