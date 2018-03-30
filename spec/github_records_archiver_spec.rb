RSpec.describe GitHubRecordsArchiver do
  after do
    %w[token client dest_dir].each do |option|
      described_class.instance_variable_set "@#{option}", nil
    end
  end

  it 'returns the token' do
    with_env 'GITHUB_TOKEN', 'TOKEN' do
      expect(described_class.token).to eql('TOKEN')
    end
  end

  it 'returns the Octokit client' do
    with_env 'GITHUB_TOKEN', 'TOKEN' do
      expect(described_class.client).to be_a(Octokit::Client)
      expect(described_class.client.access_token).to eql('TOKEN')
    end
  end

  it 'sets the default destination directory' do
    path = File.expand_path '../archive', __dir__
    expect(described_class.dest_dir).to eql(path)
  end

  it 'exposes the version' do
    expect(described_class::VERSION).to match(/\d\.\d\.\d/)
  end
end
