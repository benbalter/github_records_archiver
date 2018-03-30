# GitHub Records Archiver

[![Build Status](https://travis-ci.org/benbalter/github_records_archiver.svg?branch=master)](https://travis-ci.org/benbalter/github_records_archiver) [![Gem Version](https://badge.fury.io/rb/github_records_archiver.svg)](http://badge.fury.io/rb/github_records_archiver) [![Coverage Status](https://coveralls.io/repos/github/benbalter/github_records_archiver/badge.svg)](https://coveralls.io/github/benbalter/github_records_archiver) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Backs up a GitHub organization's repositories and all their associated information for archival purposes.

## What it archives

* Git data (change history, tags, branches, etc.)
* Wikis (including change history)
* Issues and pull request (including comments, current state, etc.)
* Teams (including members and repository permissions)

## Requirements

1. Ruby
2. A GitHub [personal access token](https://github.com/settings/tokens/new) with `repo` scope.

## Setup

If you have Ruby installed, simply run `gem install github_records_archiver` to install.

## Usage

`github_records_archiver [ORGANIZATION]`

You'll want to set the following environmental variable:

* `GITHUB_TOKEN` - Your personal access token

You *may* set the following environmental variables:

* `GITHUB_ARCHIVE_DIR` to specify the output directory. It will default to `./archive`.
* `GITHUB_ORGANIZATION` - The organization to archive if none is passed as an argument.

These can be passed as `GITHUB_TOKEN=123ABC GITHUB_ORGANIZATION=whitehouse github_records_archiver`.

You can also add the values to a `.env` file in the project's root directory, which will be automatically set as environmental variables.

## Output

The script will create an `archive` directory, with one folder for each repository.

Within each folder will be the repository content as a git repository.

If the repository has a Wiki, the wiki will be cloned as a `wiki` subfolder, as a Git repository.

If the repository has issues or pull requests, it will create an `issues` sub-folder with each issue and its associated comments stored as both markdown (human readable) and JSON (machine readable).
