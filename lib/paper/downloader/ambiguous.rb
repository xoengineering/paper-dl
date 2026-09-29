module Paper
  module Downloader
    class Ambiguous < Error
      def initialize input:, sources:
        names = sources.map(&:name).sort

        super("#{input} could be #{list names}. Prefix it to choose, like #{names.first}:#{input}")
      end

      private

      def list names
        return names.join(' or ') if names.size <= 2

        "#{names[0..-2].join ', '}, or #{names.last}"
      end
    end
  end
end
