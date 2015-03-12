# - encoding: utf-8 -

module Scripref

  module Pipelining

    refine String do
      def >> o
        o << self
      end
    end

    refine Array do
      def >> o
        o << self
      end
    end

  end

end

