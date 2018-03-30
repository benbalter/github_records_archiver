RSpec.describe GitHubRecordsArchiver::Issue do
  let(:repository) { 'balter-test-org/some-repo' }
  let(:number) { 1 }
  let(:md_path) { subject.send(:path) }
  let(:json_path) { subject.send(:path, 'json') }
  subject { described_class.new(repository: repository, number: number) }

  before do
    stub_api_request('repos/balter-test-org/some-repo')
    stub_api_request('repos/balter-test-org/some-repo/issues/1')
    stub_api_request('repos/balter-test-org/some-repo/issues/1/comments', per_page: 100)
  end

  it 'stores the repo' do
    expect(subject.repository).to be_a(GitHubRecordsArchiver::Repository)
    expect(subject.repository.name).to eql(repository)
  end

  it 'stores the number' do
    expect(subject.number).to eql(number)
  end

  context 'from a hash' do
    let(:hash) do
      {
        number: number
      }
    end

    subject { described_class.from_hash(repository, hash) }

    it 'stores the number' do
      expect(subject.number).to eql(number)
    end

    it 'stores the repo' do
      expect(subject.repository).to be_a(GitHubRecordsArchiver::Repository)
      expect(subject.repository.name).to eql(repository)
    end

    it 'stores the data' do
      expect(subject.data).to eql(hash)
    end
  end

  it 'retrieves metadata' do
    expect(subject.data).to be_a(Sawyer::Resource)
    expect(subject.data.number).to eql(number)
  end

  it 'retrieves comments' do
    expect(subject.comments).to be_an(Array)
    expect(subject.comments.first).to be_a(GitHubRecordsArchiver::Comment)
    expect(subject.comments.first.body).to eql('Me too')
  end

  it 'converts to a string' do
    expected = <<EXP
---
title: Found a bug
number: 1
state: open
html_url: https://github.com/balter-test-org/some-repo/issues/1347
created_at: 2011-04-22 13:33:48.000000000 Z
closed_at: 2011-04-22 13:34:48.000000000 Z
user: balter-test-org
assignee: balter-test-org
tags:
- bug
---

# Found a bug

I'm having a problem with this.

---
@octocat at 2011-04-14 16:00:49 UTC wrote:

Me too
EXP
    expect(subject.to_s).to eql(expected.strip)
  end

  it 'converts to json' do
    data = JSON.parse(subject.to_json)
    expect(data['number']).to eql(1)
    expect(data).to have_key('comments')
    expect(data['comments']).to be_an(Array)
    expect(data['comments'].first['id']).to eql(1)
  end

  it 'builds the issue path' do
    base_path = File.expand_path "../../archive/#{repository}/issues/#{number}", __dir__
    expect(md_path).to eql("#{base_path}.md")
    expect(json_path).to eql("#{base_path}.json")
  end

  context 'archiving' do
    before do
      FileUtils.rm_rf md_path
      FileUtils.rm_rf json_path
      subject.archive
    end

    it 'writes MD' do
      expect(File.exist?(md_path)).to be_truthy
      contents = File.read(md_path)
      expect(contents).to match(/# Found a bug/)
    end

    it 'writes JSON' do
      expect(File.exist?(json_path)).to be_truthy
      contents = File.read(json_path)
      expect(contents).to match('{\"id\":1,')
    end
  end
end
