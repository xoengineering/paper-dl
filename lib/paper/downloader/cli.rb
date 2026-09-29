module Paper
  module Downloader
    # dl-core's CLI, routing each target to its source. Each source's papers go
    # in their own subfolder of the root (<root>/arxiv/, <root>/jstor/, …).
    class CLI < DL::Core::CLI
      SOURCE_URL = 'https://github.com/xoengineering/paper-dl'.freeze

      def program = 'paper-dl'

      def target_name = 'PAPER_ID_OR_URL'

      # PAPER_DOWNLOAD_PATH, PAPER_RATE_LIMIT
      def env_prefix = 'PAPER'

      def default_path = File.join(Dir.home, 'Downloads', 'Papers')

      def version = VERSION

      def user_agent = "paper-dl/#{VERSION} (+#{SOURCE_URL})"

      def client_for(rate_limit:, log:) = Clients.new(rate_limit:, log:)

      def identifier_for(target) = router.route(target)

      def archive_for route, root:, client:
        source = route.source

        source.archive_class.new route.identifier, root: File.join(root, source.name), client: client.for(source)
      end

      private

      def router
        @router ||= Router.new
      end
    end
  end
end
