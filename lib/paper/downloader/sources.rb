module Paper
  module Downloader
    SOURCES = [
      Source.new(
        name:             'arxiv',
        identifier_class: Arxiv::Downloader::Identifier,
        archive_class:    Arxiv::Downloader::Archive,
        client_class:     Arxiv::Downloader::Client
      ),
      Source.new(
        name:             'jstor',
        identifier_class: Jstor::Downloader::Identifier,
        archive_class:    Jstor::Downloader::Archive,
        client_class:     Jstor::Downloader::Client
      ),
      Source.new(
        name:             'hal',
        identifier_class: HAL::Downloader::Identifier,
        archive_class:    HAL::Downloader::Archive,
        client_class:     HAL::Downloader::Client
      ),
      Source.new(
        name:             'ntrs',
        identifier_class: NTRS::Downloader::Identifier,
        archive_class:    NTRS::Downloader::Archive,
        client_class:     NTRS::Downloader::Client
      ),
      Source.new(
        name:             'osf',
        identifier_class: OSF::Downloader::Identifier,
        archive_class:    OSF::Downloader::Archive,
        client_class:     OSF::Downloader::Client
      ),
      Source.new(
        name:             'zenodo',
        identifier_class: Zenodo::Downloader::Identifier,
        archive_class:    Zenodo::Downloader::Archive,
        client_class:     Zenodo::Downloader::Client
      )
    ].freeze
  end
end
