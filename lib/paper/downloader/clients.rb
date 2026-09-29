module Paper
  module Downloader
    # One polite client per source, made when first needed. Each source is a
    # different server, so each gets its own rate limit and its gem's User-Agent.
    # A source is never asked to go faster than its own gem's default (OSF allows
    # far fewer requests than the others).
    class Clients
      def initialize rate_limit:, log:
        @rate_limit = rate_limit
        @log        = log
        @by_source  = {}
      end

      def for source
        @by_source[source.name] ||= source.client_class.new rate_limit: rate_limit_for(source), log: @log
      end

      private

      def rate_limit_for source
        [@rate_limit, source.client_class::DEFAULT_RATE_LIMIT].max
      end
    end
  end
end
