require_relative 'lib/paper/downloader/version'

Gem::Specification.new do |spec|
  spec.name    = 'paper-dl'
  spec.version = Paper::Downloader::VERSION
  spec.authors = ['Shane Becker']
  spec.email   = ['veganstraightedge@gmail.com']

  spec.summary     = 'Download papers from arxiv, JSTOR, HAL, and more for offline archives, with one command.'
  spec.description = <<~DESCRIPTION
    Umbrella for the <site>-dl gems (arxiv-dl, jstor-dl, hal-dl, and more).
    Routes each paper ID or URL to the gem that handles it. In development.
  DESCRIPTION
  spec.homepage = 'https://github.com/xoengineering/paper-dl'

  spec.license = 'MIT'
  spec.required_ruby_version = '>= 4.0.7'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/xoengineering/paper-dl'
  spec.metadata['bug_tracker_uri']   = 'https://github.com/xoengineering/paper-dl/issues'
  spec.metadata['changelog_uri']     = 'https://github.com/xoengineering/paper-dl/blob/main/CHANGELOG.md'

  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) || f.start_with?(
        *%w[
          .github/
          .gitignore
          .rspec
          .rubocop.yml
          .ruby-version
          Gemfile
          Rakefile
          bin/
          script/
          spec/
          tasks/
        ]
      )
    end
  end
  spec.require_paths = ['lib']
end
