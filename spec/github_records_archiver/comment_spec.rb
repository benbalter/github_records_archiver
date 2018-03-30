RSpec.describe GitHubRecordsArchiver::Comment do
  let(:repo) { 'balter-test-org/some-repo' }
  let(:id) { 1 }
  subject { described_class.new(repo, id) }

  before do
    stub_api_request('repos/balter-test-org/some-repo')
    stub_api_request('repos/balter-test-org/some-repo/issues/comments/1', per_page: 100)
  end

  it 'stores the repo' do
    expect(subject.repository).to be_a(GitHubRecordsArchiver::Repository)
    expect(subject.repository.full_name).to eql(repo)
  end

  it 'stores the ID' do
    expect(subject.id).to eql(id)
  end

  context 'when given a repository' do
    subject do
      repository = GitHubRecordsArchiver::Repository.new(repo)
      described_class.new(repository, id)
    end

    it 'stores the repo' do
      expect(subject.repository).to be_a(GitHubRecordsArchiver::Repository)
      expect(subject.repository.full_name).to eql(repo)
    end
  end

  context '#from_hash' do
    let(:hash) do
      { number: id }
    end

    subject { described_class.from_hash(repo, hash) }

    it 'store the number' do
      expect(subject.number).to eql(id)
    end

    it 'stores the data' do
      expect(subject.data[:number]).to eql(id)
    end
  end

  it 'returns metadata' do
    expect(subject.data).to be_a(Sawyer::Resource)
    expect(subject.data.body).to eql('Me too')
  end

  it 'converts to a string' do
    expected = "@balter-test-org at 2011-04-14 16:00:49 UTC wrote:\n\nMe too"
    expect(subject.to_s).to eql(expected)
  end
end
