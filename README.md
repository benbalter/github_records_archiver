# GitHub Records Archiver

Backs up a GitHub organization's repositories and all their associated information for archival purposes.

## What it archives

* Git data (change history, tags, branches, etc.)
* Wikis (including change history)
* Issues and pull request (including comments, current state, etc.)
* Teams (including members and repository permissions)

## Requirements

1. Ruby
2. A GitHub [personal access token](https://github.com/settings/tokens/new) with `public_repo` and `repo` scope.

## Setup

1. `git clone https://github.com/benbalter/github-records-archiver`
2. `cd github-records-archiver`
3. `gem install bundler`
4. `bundle install`

## Usage

`bin/archive [ORGANIZATION]`

You'll want to set the following environmental variable:

* `GITHUB_TOKEN` - Your personal access token

You *may* set the following environmental variables:

* `GITHUB_ARCHIVE_DIR` to specify the output directory. It will default to `./archive`.
* `GITHUB_ORGANIZATION` - The organization to archive if none is passed as an argument.

These can be passed as `GITHUB_TOKEN=123ABC GITHUB_ORGANIZATION=whitehouse bin/archive`.

You can also add the values to a `.env` file in the project's root directory, which will be automatically set as environmental variables.

## Output

The script will create an `archive` directory, with one folder for each repository.

Within each folder will be the repository content as a git repository.

If the repository has a Wiki, the wiki will be cloned as a `wiki` subfolder, as a Git repository.

If the repository has issues or pull requests, it will create an `issues` sub-folder with each issue and its associated comments stored as both markdown (human readable) and JSON (machine readable).
