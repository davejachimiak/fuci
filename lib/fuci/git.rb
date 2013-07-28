module Fuci
  module Git
    CURRENT_BRANCH_COMMAND    = "git branch | sed -n '/\* /s///p'"
    REMOTE_MASTER_SHA_COMMAND = "git rev-parse origin/master"
    REMOTE_REPO_COMMAND       =
      "git remote -v | grep origin | grep push | awk 'match($0, /:\(.*)\.git/) { print substr($0, RSTART+1, RLENGTH-5) }'"

    def current_branch_name
      with_popen current_branch_command
    end

    def remote_repo_name
      with_popen remote_repo_command
    end

    def remote_master_sha
      with_popen remote_master_sha_command
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

    def remote_master_sha_command
      REMOTE_MASTER_SHA_COMMAND
    end
  end
end
