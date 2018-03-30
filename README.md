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

## Basic usage

```shell
$ github_records_archiver archive ORGANIZATION --token PERSONAL_ACCESS_TOKEN`
```
Alternatively, you could pass the personal access token as the `GITHUB_TOKEN` environmental variable:

```shell
$ GITHUB_TOKEN=1234 github_records_archiver archive ORGANIZATION`
```

## Output

The script will create an `archive` directory, with one folder for each organization.

Within each organization folder, there will be one folder per repository.

Within each repository folder will be the repository content as a git repository.

If the repository has a Wiki, the wiki will be cloned as a `wiki` subfolder, as a Git repository.

If the repository has issues or pull requests, it will create an `issues` sub-folder with each issue and its associated comments stored as both markdown (human readable) and JSON (machine readable).

Example output:

```
├─ archive
├─── organization
├──── repository
├────── README.md
├────── LICENSE.txt
├──── wiki
├────── wiki-page.md
├──── issues
├────── 1.md
├────── 1.json
├─── another organization
├──── another-repository
├────── README.md
├────── LICENSE.txt
├──── wiki
├────── wiki-page.md
├──── issues
├────── 1.md
├────── 1.json
```

## Advanced usage

You may set the following flags:

* `--dest-dir` - the destination archive directory, defaults to `./archive`
* `--verbose` - verbose output while archiving

Additionally, the following commands are also available:

* `delete [ORGANIZATION]` - delete the entire archive directory or an organization's archive
* `help` - display help information
* `version` - display the GitHub Record Archiver version
