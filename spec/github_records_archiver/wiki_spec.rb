RSpec.describe GitHubRecordsArchiver::Wiki do
  let(:repo) { 'balter-test-org/some-repo' }
  subject { described_class.new(repo) }

  before do
    stub_api_request('repos/balter-test-org/some-repo')
  end

  it 'stores the repo' do
    expect(subject.repository).to be_a(GitHubRecordsArchiver::Repository)
    expect(subject.repository.name).to eql(repo)
  end

  context 'when initialized with a Repository object' do
    subject do
      repository = GitHubRecordsArchiver::Repository.new(repo)
      described_class.new(repository)
    end

    it 'stores the repo' do
      expect(subject.repository).to be_a(GitHubRecordsArchiver::Repository)
      expect(subject.repository.name).to eql(repo)
    end
  end

  it 'builds the repo dir' do
    path = File.expand_path "../../archive/#{repo}/wiki", __dir__
    expect(subject.repo_dir).to eql(path)
  end

  it 'builds the clone URL' do
    expected = "https://TEST_TOKEN:x-oauth-basic@github.com/#{repo}.wiki.git"
    expect(subject.send(:clone_url)).to eql(expected)
  end
end
