module Paper
  module Downloader
    # A target matched to the source that handles it
    Route = Data.define :source, :identifier do
      def id = identifier.id
    end
  end
end
