module Fuci
  class Server

    # Must return a string with characters denoting ascii color removed.
    def fetch_log
      raise NotImplementedError
    end

    private

    def remove_ascii_color_chars string
      string.gsub /\e\[(\d+)m/, ""
    end
  end
end
