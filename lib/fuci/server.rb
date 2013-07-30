module Fuci
  class Server

    # must return either of the following
    # symbols:
    # :red (failure),
    # :yellow (errored),
    # :green (passing)
    def build_status
      raise NotImplementedError
    end

    # must return a log as as string string with characters
    # denoting ascii color removed
    def fetch_log
      raise NotImplementedError
    end

    private

    def remove_ascii_color_chars string
      string.gsub /\e\[(\d+)m/, ""
    end
  end
end
