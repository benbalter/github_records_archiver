
RSpec.describe GitHubRecordsArchiver::GitRepository do
  class GitRepositorySpec < described_class
    def repo_dir
      File.join GitHubRecordsArchiver.dest_dir, 'git-repo'
    end

    private

    def clone_url
      File.join fixture_dir, 'git-repo'
    end
  end

  before do
    FileUtils.rm_rf subject.repo_dir
  end

  subject { GitRepositorySpec.new }

  it 'clones' do
    subject.clone
    expect(Dir.exist?(subject.repo_dir)).to be_truthy
  end

  it 'pulls' do
    subject.clone
    subject.clone
    expect(Dir.exist?(subject.repo_dir)).to be_truthy
  end
end
