RSpec.describe GitHubRecordsArchiver::User do
  let(:login) { 'benbalter' }
  subject { described_class.new(login) }

  before do
    stub_api_request 'users/benbalter'
  end

  it 'stores the login' do
    expect(subject.login).to eql(login)
    expect(subject.name).to eql(login)
  end

  context 'when given a hash' do
    let(:hash) do
      {
        login: login
      }
    end

    subject { described_class.new(hash) }

    it 'stores the login' do
      expect(subject.login).to eql(login)
    end

    it 'stores the data' do
      expect(subject.data).to eql(hash)
    end
  end

  it 'retrieves metadata' do
    expect(subject.data).to be_a(Sawyer::Resource)
    expect(subject.data.login).to eql(login)
  end
end
