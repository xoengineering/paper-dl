RSpec.describe Paper::Downloader::Clients do
  def source_named name
    Paper::Downloader::SOURCES.find { it.name == name }
  end

  it "makes one client per source, of that source's client class" do
    clients = described_class.new rate_limit: 3, log: nil

    first = clients.for source_named('jstor')

    expect(first).to be_a Jstor::Downloader::Client
    expect(clients.for(source_named('jstor'))).to be first
  end

  it 'uses the requested rate limit for a source whose own default is faster' do
    clients = described_class.new rate_limit: 5, log: nil

    expect(clients.for(source_named('zenodo')).rate_limit).to eq 5
  end

  it "never goes faster than a source's own default" do
    clients = described_class.new rate_limit: 3, log: nil

    expect(clients.for(source_named('osf')).rate_limit).to eq 36
  end
end
