$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'yaml'
require 'json'
require 'logger'
require 'fileutils'
require 'open3'
require 'thor'
require 'octokit'
require 'dotenv/load'

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
    attr_writer :token, :dest_dir, :verbose, :shell, :client

    def token
      @token ||= ENV['GITHUB_TOKEN']
    end

    def client
      @client ||= Octokit::Client.new access_token: token
    end

    def dest_dir
      @dest_dir ||= File.expand_path('./archive', Dir.pwd)
    end

    def verbose
      @verbose ||= false
    end
    alias verbose? verbose

    def shell
      @shell ||= Thor::Base.shell.new
    end

    def verbose_status(status, message, color = :white)
      return unless verbose?
      shell.say_status status, remove_token(message), color
    end

    def remove_token(string)
      string.gsub(GitHubRecordsArchiver.token, '<GITHUB_TOKEN>')
    end
  end
end
