RSpec.describe Paper::Downloader::Router do
  let(:router) { described_class.new }

  def source_for input
    router.route(input).source.name
  end

  describe '#route' do
    {
      '2508.16190'                                  => 'arxiv',
      'https://arxiv.org/abs/2508.16190v1'          => 'arxiv',
      'cs/0002001'                                  => 'arxiv',
      'https://www.jstor.org/stable/4385670'        => 'jstor',
      '10.2307/4385670'                             => 'jstor',
      'https://archive.org/details/jstor-4385670'   => 'jstor',
      'hal-01207234v1'                              => 'hal',
      'https://hal.science/hal-01207234'            => 'hal',
      'https://ntrs.nasa.gov/citations/19700020471' => 'ntrs',
      '10.5281/zenodo.884117'                       => 'zenodo',
      'https://zenodo.org/records/884117'           => 'zenodo',
      'https://osf.io/preprints/psyarxiv/cjy8e_v1/' => 'osf',
      '10.31234/osf.io/cjy8e_v1'                    => 'osf',
      'cjy8e'                                       => 'osf'
    }.each do |input, source|
      it "routes #{input.inspect} to #{source}" do
        expect(source_for(input)).to eq source
      end
    end

    it "passes that source's identifier along" do
      route = router.route 'https://www.jstor.org/stable/4385670'

      expect(route.identifier).to be_a Jstor::Downloader::Identifier
      expect(route.id).to eq '4385670'
    end

    context 'with a bare number that more than one source accepts' do
      it 'raises Ambiguous, naming the candidates and how to choose' do
        expect { router.route '4385670' }.to raise_error(
          Paper::Downloader::Ambiguous,
          '4385670 could be jstor or zenodo. Prefix it to choose, like jstor:4385670'
        )
      end

      it 'includes ntrs for an 11-digit number' do
        expect { router.route '19700020471' }
          .to raise_error Paper::Downloader::Ambiguous, /could be jstor, ntrs, or zenodo/
      end
    end

    context 'with a source prefix' do
      {
        'jstor:4385670'    => 'jstor',
        'zenodo:884117'    => 'zenodo',
        'ntrs:19700020471' => 'ntrs',
        'hal:hal-01207234' => 'hal',
        'arxiv:2508.16190' => 'arxiv',
        'ZENODO:884117'    => 'zenodo'
      }.each do |input, source|
        it "routes #{input.inspect} to #{source}" do
          expect(source_for(input)).to eq source
        end
      end

      it "raises that source's error when it does not recognize the rest" do
        expect { router.route 'ntrs:4385670' }.to raise_error NTRS::Downloader::Identifier::Invalid
      end
    end

    context 'with input no source recognizes' do
      it 'raises Unrecognized' do
        expect { router.route 'not a paper' }.to raise_error(
          Paper::Downloader::Unrecognized,
          'not a paper ID or URL that arxiv, jstor, hal, ntrs, osf, or zenodo recognizes: not a paper'
        )
      end
    end
  end
end
