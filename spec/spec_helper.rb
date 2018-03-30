require 'coveralls'
Coveralls.wear!

require 'webmock'
require 'webmock/rspec'
require 'addressable/uri'
require_relative '../lib/github_records_archiver'

ENV['GITHUB_TOKEN'] = 'TEST_TOKEN'

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random

  config.default_formatter = 'doc' if config.files_to_run.one?

  Kernel.srand config.seed
  WebMock.disable_net_connect!
end

def with_env(key, value)
  old_env = ENV[key]
  ENV[key] = value
  yield
  ENV[key] = old_env
end

def fixture_dir
  File.join(__dir__, 'fixtures')
end

def fixture_path(fixture)
  File.join(fixture_dir, "#{fixture}.json")
end

def fixture_contents(fixture)
  path = fixture_path(fixture)
  raise "Missing fixture for '#{fixture}'" unless File.exist?(path)
  File.read(path)
end

def stub_api_request(fixture, args = nil)
  uri = Addressable::URI.join('https://api.github.com', fixture)
  uri.query_values = args if args
  stub_request(:get, uri).to_return(
    status: 200,
    body: fixture_contents(fixture),
    headers: { 'Content-Type' => 'application/json' }
  )
end
