module Fuci
  class Server

    # Must return a string with character denoting ascii color removed.
    def fetch_log
      raise NotImplementedError
    end
  end
end
