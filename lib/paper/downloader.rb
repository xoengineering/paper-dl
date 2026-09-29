require 'dl/core'
require 'arxiv/downloader'
require 'hal/downloader'
require 'jstor/downloader'
require 'ntrs/downloader'
require 'zenodo/downloader'

require_relative 'downloader/error'        # before the errors below that subclass Error
require_relative 'downloader/source'       # before sources: SOURCES is a list of Source
require_relative 'downloader/version'

require_relative 'downloader/ambiguous'    # after error
require_relative 'downloader/cli'
require_relative 'downloader/clients'
require_relative 'downloader/route'
require_relative 'downloader/router'
require_relative 'downloader/sources'      # after source
require_relative 'downloader/unrecognized' # after error

module Paper
  module Downloader
  end
end
