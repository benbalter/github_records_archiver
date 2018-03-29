require 'webmock'
WebMock.disable_net_connect!

require_relative '../lib/github_records_archiver'

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random

  config.default_formatter = 'doc' if config.files_to_run.one?

  Kernel.srand config.seed
end

def with_env(key, value)
  old_env = ENV[key]
  ENV[key] = value
  yield
  ENV[key] = old_env
end
