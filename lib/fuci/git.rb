module Fuci
  module Git
    MASTER                         = 'master'
    CURRENT_BRANCH_COMMAND         = "git branch | sed -n '/\* /s///p'"
    REMOTE_SHA_FROM_BRANCH_COMMAND = lambda { |branch_name| "git rev-parse origin/#{branch_name}" }
    REMOTE_REPO_COMMAND            =
      "git remote -v | grep origin | grep push | awk 'match($0, /:\(.*)\.git/) { print substr($0, RSTART+1, RLENGTH-5) }'"

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
      sha = with_popen pull_merge_sha_command(branch_name)
      sha.empty? ? raise(NoPullError) : sha
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

    class NoPullError < StandardError; end;
  end
end
