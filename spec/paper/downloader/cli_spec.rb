require 'tmpdir'

# Option parsing, --input, and error reporting are specified in dl-core.
RSpec.describe Paper::Downloader::CLI do
  let(:stdout) { StringIO.new }
  let(:stderr) { StringIO.new }
  let(:jstor_dir)  { 'jstor/1907/10/05/clasweek/4385670-the-elements-of-the-translation-of-latin' }
  let(:zenodo_dir) do
    'zenodo/2017/09/04/preprint/884116-the-computer-says-debt-towards-a-critical-sociology-of-algorithms-and'
  end

  before do
    fixtures = 'spec/fixtures/http'
    stub_request(:get, 'https://archive.org/metadata/jstor-4385670')
      .to_return(status: 200, body: File.read("#{fixtures}/metadata-4385670.json"))
    stub_request(:get, 'https://archive.org/download/jstor-4385670/4385670.pdf')
      .to_return(status: 200, body: File.binread("#{fixtures}/pdf-4385670.pdf"))
    stub_request(:get, 'https://archive.org/download/jstor-4385670/4385670_djvu.txt')
      .to_return(status: 200, body: File.read("#{fixtures}/text-4385670.txt"))
    stub_request(:get, 'https://archive.org/download/jstor-4385670/10.2307_4385670.xml')
      .to_return(status: 200, body: File.read("#{fixtures}/jstor-xml-4385670.xml"))
    stub_request(:get, 'https://zenodo.org/api/records/884117')
      .to_return(status: 200, body: File.read("#{fixtures}/record-884117.json"))
    stub_request(:get, 'https://zenodo.org/api/records/884117/files/Data_for_Policy_2017_paper_43.pdf/content')
      .to_return(status: 200, body: File.binread("#{fixtures}/file-884117-Data_for_Policy_2017_paper_43.pdf"))
  end

  def run_with arguments
    described_class.new(arguments, stderr:, stdout:).run
  end

  it 'archives papers from different sources, each under its own subfolder' do
    Dir.mktmpdir do |root|
      status = run_with ['-p', root, '--rate-limit', '0', '10.2307/4385670', 'https://zenodo.org/records/884117']

      expect(status).to eq 0
      expect(stdout.string.lines.map(&:chomp)).to eq [File.join(root, jstor_dir), File.join(root, zenodo_dir)]
    end
  end

  it 'reports an ambiguous bare number and keeps going' do
    Dir.mktmpdir do |root|
      status = run_with ['-p', root, '--rate-limit', '0', '4385670', 'jstor:4385670']

      expect(status).to eq 1
      expect(stderr.string).to start_with '4385670: 4385670 could be jstor or zenodo.'
      expect(stdout.string).to eq "#{File.join(root, jstor_dir)}\n"
    end
  end

  it 'uses one client per source, each with that gem’s User-Agent' do
    Dir.mktmpdir do |root|
      run_with ['-p', root, '--rate-limit', '0', 'jstor:4385670', 'zenodo:884117']

      expect(WebMock).to have_requested(:get, 'https://archive.org/metadata/jstor-4385670')
        .with(headers: { 'User-Agent' => Jstor::Downloader::Client::USER_AGENT })
      expect(WebMock).to have_requested(:get, 'https://zenodo.org/api/records/884117')
        .with(headers: { 'User-Agent' => Zenodo::Downloader::Client::USER_AGENT })
    end
  end

  it "uses paper-dl's usage line and version" do
    run_with ['-h']
    run_with ['--version']

    expect(stdout.string).to start_with 'Usage: paper-dl [options] <PAPER_ID_OR_URL>'
    expect(stdout.string).to end_with "#{Paper::Downloader::VERSION}\n"
  end
end
