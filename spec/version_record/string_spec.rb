describe String do
  describe '#to_version' do
    it { expect('2.2.1'.to_version).to eq VersionRecord::Version.new('2.2.1') }
    it { expect('2.2.1.beta'.to_version).to eq VersionRecord::Version.new('2.2.1.beta') }
    it { expect { 'invalid_version'.to_version }.to raise_error(ArgumentError) }
  end
end
