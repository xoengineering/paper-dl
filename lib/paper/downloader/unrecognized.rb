module Paper
  module Downloader
    class Unrecognized < Error
      def initialize input:, sources:
        names = sources.map(&:name)

        super("not a paper ID or URL that #{names[0..-2].join ', '}, or #{names.last} recognizes: #{input}")
      end
    end
  end
end
