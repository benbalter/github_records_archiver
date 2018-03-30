RSpec.describe GitHubRecordsArchiver::Team do
  let(:id) { 1 }
  let(:org) { 'balter-test-org' }
  subject { described_class.new(org, id) }

  before do
    stub_api_request('orgs/balter-test-org')
    stub_api_request('teams/1')
    stub_api_request('teams/1/repos', per_page: 100)
    stub_api_request('teams/1/members', per_page: 100)
  end

  it 'stores the ID' do
    expect(subject.id).to eql(id)
  end

  it 'stores the org' do
    organization = GitHubRecordsArchiver::Organization.new(org)
    expect(subject.organization.id).to eql(organization.id)
  end

  context 'from a hash' do
    let(:hash) do
      {
        id: id
      }
    end

    subject { described_class.from_hash(org, hash) }

    it 'stores the ID' do
      expect(subject.id).to eql(id)
    end

    it 'store the org' do
      organization = GitHubRecordsArchiver::Organization.new(org)
      expect(subject.organization.id).to eql(organization.id)
    end

    it 'stores the metadata' do
      expect(subject.data).to eql(hash)
    end
  end

  it 'retrieves metadata' do
    expect(subject.data).to be_a(Sawyer::Resource)
    expect(subject.data.id).to eql(id)
  end

  it 'retrieves repos' do
    expect(subject.repositories).to be_an(Array)
    repo = subject.repositories.first
    expect(repo).to be_a(GitHubRecordsArchiver::Repository)
  end

  it 'retrives members' do
    expect(subject.members).to be_an(Array)
    user = subject.members.first
    expect(user).to be_a(GitHubRecordsArchiver::User)
  end

  it 'converts to a string' do
    expected = <<EXPECTED
---
name: Justice League
slug: justice-league
description: A great team.
privacy: closed
permission: admin
repositories:
- balter-test-org/Hello-World
members:
- octocat
EXPECTED
    expect(subject.to_s).to eql(expected)
  end

  it 'converts to JSON' do
    data = JSON.parse(subject.to_json)
    expect(data).to have_key('id')
    expect(data['id']).to eql(id)
    expect(data['name']).to eql('Justice League')
  end
end
