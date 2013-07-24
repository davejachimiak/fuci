module Fuci
  module Configurable
    module ClassMethods
      def configure
        yield self
      end
    end

    def self.included base
      base.extend ClassMethods
    end
  end
end
