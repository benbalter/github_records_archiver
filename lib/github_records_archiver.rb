$LOAD_PATH.unshift(File.dirname(__FILE__))

# stdlib
require 'yaml'
require 'json'
require 'logger'
require 'fileutils'
require 'open3'

# gems
require 'octokit'
require 'dotenv'

# Configuration
Dotenv.load
Octokit.auto_paginate = true

module GitHubRecordsArchiver
  autoload :DataHelper,    'github_records_archiver/data_helper'
  autoload :Comment,       'github_records_archiver/comment'
  autoload :GitRepository, 'github_records_archiver/git_repository'
  autoload :Issue,         'github_records_archiver/issue'
  autoload :Organization,  'github_records_archiver/organization'
  autoload :Repository,    'github_records_archiver/repository'
  autoload :Team,          'github_records_archiver/team'
  autoload :User,          'github_records_archiver/user'
  autoload :VERSION,       'github_records_archiver/version'
  autoload :Wiki,          'github_records_archiver/wiki'

  class << self
    def token
      ENV['GITHUB_TOKEN']
    end

    def client
      @client ||= Octokit::Client.new access_token: token
    end

    def dest_dir
      ENV['GITHUB_ARCHIVE_DIR'] || File.expand_path('./archive', Dir.pwd)
    end
  end
end
