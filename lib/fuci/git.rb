module Fuci
  module Git
    MASTER                 = 'master'
    CURRENT_BRANCH_COMMAND = "git branch | sed -n '/\* /s///p'"
    REMOTE_REPO_COMMAND    =
      "git remote -v | grep origin | grep push | awk 'match($0, /:\(.*)\.git/) { print substr($0, RSTART+1, RLENGTH-5) }'"
    REMOTE_SHA_FROM_BRANCH_COMMAND =
      lambda { |branch_name| "git rev-parse origin/#{branch_name}" }
    PULL_MERGE_SHA_FROM_NUMBER_COMMAND =
      lambda { |pull_number| "git ls-remote origin | grep refs\\/pull\\/#{pull_number}\\/merge | awk '{ print $1 };'" }
    PULL_NUMBER_FROM_SHA_COMMAND =
      lambda { |sha| "git ls-remote origin | grep #{sha} | grep pull | perl -n -e '/pull\\/(.*)\\/head/ && print $1'" }

    def current_branch_name
      with_popen current_branch_command
    end

    def remote_repo_name
      with_popen remote_repo_command
    end

    def remote_master_sha
      with_popen remote_sha_from_branch_command(MASTER)
    end

    def remote_sha_from branch_name
      with_popen remote_sha_from_branch_command(branch_name)
    end

    def pull_merge_sha_from branch_name
      pull_number = pull_number_from branch_name
      command = pull_merge_sha_command(pull_number)
      puts command
      with_popen pull_merge_sha_command(pull_number)
    end

    def pull_number_from branch_name
      remote_sha  = remote_sha_from branch_name
      pull_number = with_popen pull_number_from_sha_command(remote_sha)

      pull_number.empty? ? raise(NoPullError) : pull_number
    end

    private

    def with_popen command
      IO.popen command do |io|
        io.first.chomp
      end
    end

    def current_branch_command
      CURRENT_BRANCH_COMMAND
    end

    def remote_repo_command
      REMOTE_REPO_COMMAND
    end

    def remote_sha_from_branch_command branch_name
      REMOTE_SHA_FROM_BRANCH_COMMAND.(branch_name)
    end

    def pull_merge_sha_command pull_number
      PULL_MERGE_SHA_FROM_NUMBER_COMMAND.(pull_number)
    end

    def pull_number_from_sha_command sha
      PULL_NUMBER_FROM_SHA_COMMAND.(sha)
    end

    class NoPullError < StandardError; end;
  end
end
