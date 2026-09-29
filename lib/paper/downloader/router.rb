module Paper
  module Downloader
    # Matches each target to the one source that recognizes it. A "<source>:" prefix
    # (jstor:4385670) picks the source outright, for input several sources accept.
    class Router
      def initialize sources: SOURCES
        @sources = sources
      end

      def route input
        text   = input.to_s.strip
        source = prefixed_source text
        return Route.new(source:, identifier: source.identifier_class.new(unprefixed(text))) if source

        route_unprefixed text
      end

      private

      def route_unprefixed text
        matches = @sources.filter_map do |source|
          identifier = source.recognize text
          Route.new(source:, identifier:) if identifier
        end

        raise Unrecognized.new(input: text, sources: @sources) if matches.empty?
        raise Ambiguous.new(input: text, sources: matches.map(&:source)) if matches.size > 1

        matches.first
      end

      def prefixed_source text
        prefix = text.split(':', 2).first.downcase
        @sources.find { it.name == prefix } if text.include? ':'
      end

      def unprefixed text
        text.split(':', 2).last
      end
    end
  end
end
