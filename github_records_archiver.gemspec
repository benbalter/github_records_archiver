
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_records_archiver/version'

Gem::Specification.new do |spec|
  spec.name          = 'github_records_archiver'
  spec.version       = GitHubRecordsArchiver::VERSION
  spec.authors       = ['Ben Balter']
  spec.email         = ['ben.balter@github.com']

  spec.summary       = <<-SUMMARY
    Backs up a GitHub organization's repositories and all their associated
    information for archival purposes
  SUMMARY

  spec.homepage      = 'https://github.com/benbalter/github_records_archiver'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dotenv', '~> 2.0'
  spec.add_dependency 'octokit', '~> 4.0'
  spec.add_dependency 'parallel', '~> 1.10'
  spec.add_dependency 'ruby-progressbar', '~> 1.0'
  spec.add_dependency 'thor', '~> 0.19'
  spec.add_development_dependency 'addressable', '~> 2.5'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.50'
  spec.add_development_dependency 'webmock', '~> 3.0'
end
