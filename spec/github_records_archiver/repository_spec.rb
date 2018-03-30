RSpec.describe GitHubRecordsArchiver::Repository do
  let(:name) { 'balter-test-org/some-repo' }
  subject { described_class.new(name) }

  before do
    stub_api_request('repos/balter-test-org/some-repo')
    stub_api_request('repos/balter-test-org/some-repo/issues', per_page: 100, state: 'all')
  end

  it 'stores the name' do
    expect(subject.name).to eql(name)
  end

  context 'when initialized with a data hash' do
    subject { described_class.new(full_name: name) }

    it 'stores the name' do
      expect(subject.name).to eql(name)
    end
  end

  it 'retrieves metadata' do
    expect(subject.data).to be_a(Sawyer::Resource)
    expect(subject.name).to eql(name)
  end

  it 'retrieves wikis' do
    expect(subject.wiki).to be_a(GitHubRecordsArchiver::Wiki)
  end

  it 'retrieves issues' do
    expect(subject.issues).to be_a(Array)
    expect(subject.issues.first).to be_a(GitHubRecordsArchiver::Issue)
  end

  it 'returns the issues dir' do
    path = File.expand_path "../../archive/#{name}/issues", __dir__
    expect(subject.issues_dir).to eql(path)
    expect(Dir.exist?(subject.issues_dir)).to be_truthy
  end

  it 'builds the repo dir' do
    path = File.expand_path "../../archive/#{name}", __dir__
    expect(subject.send(:repo_dir)).to eql(path)
  end

  it 'builds the clone URL' do
    expected = 'https://TEST_TOKEN:x-oauth-basic@github.com/'
    expected << 'balter-test-org/some-repo.git'
    expect(subject.send(:clone_url)).to eql(expected)
  end
end
