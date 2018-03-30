RSpec.describe GitHubRecordsArchiver::CLI do
  let(:command) { :help }
  let(:args) { [] }
  let(:output) { capture(:stdout) { subject.public_send(command, *args) } }

  it 'displays help output' do
    expect(output).to match('GitHub Records Archiver commands:')
  end

  context 'version' do
    let(:command) { :version }

    it 'displays the version' do
      expect(output).to match(/GitHub Records Archiver v\d\.\d\.\d/)
    end
  end

  context 'delete' do
    let(:command) { :delete }
    let(:dest_dir) { GitHubRecordsArchiver.dest_dir }

    before do
      FileUtils.mkdir dest_dir unless Dir.exist?(dest_dir)
      subject.options = subject.options.merge(force: true)
    end

    it 'deletes the archive' do
      expect(Dir.exist?(dest_dir)).to be_truthy
      subject.public_send(command, *args)
      expect(Dir.exist?(dest_dir)).to be_falsy
    end

    context 'when given an organization' do
      let(:args) { ['org'] }
      let(:path) { File.join(dest_dir, 'org') }
      before do
        FileUtils.mkdir path unless Dir.exist?(path)
      end

      it 'deletes the org' do
        expect(Dir.exist?(path)).to be_truthy
        subject.public_send(command, *args)
        expect(Dir.exist?(path)).to be_falsy
        expect(Dir.exist?(dest_dir)).to be_truthy
      end
    end

    context 'archiving' do
      before do
        stub_api_request('orgs/balter-test-org')
        stub_api_request('orgs/balter-test-org/repos', per_page: 100)
        stub_api_request('orgs/balter-test-org/teams', per_page: 100)
        stub_api_request('teams/1')
        stub_api_request('teams/1/repos', per_page: 100)
        stub_api_request('teams/1/members', per_page: 100)
        stub_api_request('repos/balter-test-org/some-repo')
        stub_api_request('repos/balter-test-org/some-repo/issues/1')
        stub_api_request('repos/balter-test-org/some-repo/issues/1/comments', per_page: 100)
        stub_api_request('repos/balter-test-org/some-repo/issues/comments/1', per_page: 100)
        stub_api_request('repos/balter-test-org/some-repo/issues', per_page: 100, state: 'all')
        stub_api_request 'users/benbalter'
      end

      let(:args) { ['balter-test-org'] }
      let(:command) { :archive }

      it 'archives' do
        expect(output).to match(/^Done/)
        files = [
          'balter-test-org/some-repo/issues/1347.json',
          'balter-test-org/some-repo/issues/1347.md',
          'balter-test-org/teams/justice-league.md'
        ]

        files.each do |file|
          path = File.join dest_dir, file
          expect(File.exist?(path)).to be_truthy, "Expected #{file} to exist"
        end
      end
    end
  end
end
