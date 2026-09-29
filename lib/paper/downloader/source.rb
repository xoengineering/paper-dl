module Paper
  module Downloader
    # One <site>-dl gem: its name (also its subfolder and prefix) and its classes
    Source = Data.define :name, :identifier_class, :archive_class, :client_class do
      # the source's identifier for input, or nil when it does not recognize it
      def recognize input
        identifier_class.new input
      rescue DL::Core::Error
        nil
      end
    end
  end
end
