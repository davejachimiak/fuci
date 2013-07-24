module Fuci
  module Configurable
    def self.configure
      yield self
    end
  end
end
