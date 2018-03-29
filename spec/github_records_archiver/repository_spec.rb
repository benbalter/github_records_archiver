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
end
