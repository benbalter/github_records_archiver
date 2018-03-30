RSpec.describe GitHubRecordsArchiver::DataHelper do
  class SpecHelper
    include GitHubRecordsArchiver::DataHelper

    def data
      {
        foo: 'bar'
      }
    end
  end

  subject { SpecHelper.new }

  it 'returns values' do
    expect(subject).to respond_to(:foo)
    expect(subject.foo).to eql('bar')
  end

  it 'responds to predicate methods' do
    expect(subject).to respond_to('foo?')
    expect(subject.foo?).to be_truthy
  end

  it "doesn't respond to invalid methods" do
    expect(subject).to_not respond_to(:bar)
    expect(subject).to_not respond_to(:bar?)
  end

  it 'responds to #as_json' do
    expect(subject.as_json).to eql(subject.data.to_h)
  end

  it 'responds to #to_json' do
    expect(subject.to_json).to eql(subject.data.to_json)
  end
end
