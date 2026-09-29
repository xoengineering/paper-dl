module Paper
  module Downloader
    # One polite client per source, made when first needed. Each source is a
    # different server, so each gets its own rate limit and its gem's User-Agent.
    class Clients
      def initialize rate_limit:, log:
        @rate_limit = rate_limit
        @log        = log
        @by_source  = {}
      end

      def for source
        @by_source[source.name] ||= source.client_class.new rate_limit: @rate_limit, log: @log
      end
    end
  end
end
