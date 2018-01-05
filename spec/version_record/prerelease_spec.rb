describe VersionRecord::Prerelease do

  subject(:prerelease) { VersionRecord::Prerelease.new('.beta') }

  describe '.build' do
    it { expect(VersionRecord::Prerelease.build('beta')).to eq VersionRecord::Prerelease.new('.beta') }
  end

  describe '#to_s' do
    it { expect(prerelease.to_s).to eq '.beta' }
    it { expect(prerelease.to_s(true)).to eq '.beta' }
    it { expect(prerelease.to_s(false)).to eq 'beta' }
  end

  describe '#tail' do
    it { expect(VersionRecord::Prerelease.new('.beta.1.alpha').tail).to eq VersionRecord::Prerelease.new('.1.alpha') }
    it { expect(VersionRecord::Prerelease.new('.1.alpha').tail).to      eq VersionRecord::Prerelease.new('.alpha') }
    it { expect(VersionRecord::Prerelease.new('.alpha').tail).to        be_nil }
  end

  describe '#first_segment' do
    it { expect(VersionRecord::Prerelease.new('.beta.1.alpha').first_segment).to eq 'beta' }
    it { expect(VersionRecord::Prerelease.new('.1.alpha').first_segment).to eq '1' }
    it { expect(VersionRecord::Prerelease.new('.alpha').first_segment).to eq 'alpha' }
  end

  describe '#<=>' do
    it { expect(VersionRecord::Prerelease.new('-alpha')).to      be <  VersionRecord::Prerelease.new('-alpha.1') }
    it { expect(VersionRecord::Prerelease.new('-alpha.1')).to    be <  VersionRecord::Prerelease.new('-alpha.beta') }
    it { expect(VersionRecord::Prerelease.new('-alpha.beta')).to be <  VersionRecord::Prerelease.new('-beta') }
    it { expect(VersionRecord::Prerelease.new('-beta')).to       be <  VersionRecord::Prerelease.new('-beta.2') }
    it { expect(VersionRecord::Prerelease.new('-beta.2')).to     be <  VersionRecord::Prerelease.new('-beta.11') }
    it { expect(VersionRecord::Prerelease.new('-beta.11')).to    be <  VersionRecord::Prerelease.new('-rc.1') }
    it { expect(VersionRecord::Prerelease.new('.beta.9')).to     be <  VersionRecord::Prerelease.new('.beta.10') }
    it { expect(VersionRecord::Prerelease.new('.beta.1')).to     be >  VersionRecord::Prerelease.new('.beta') }
    it { expect(VersionRecord::Prerelease.new('.beta')).to       be <  VersionRecord::Prerelease.new('.beta.1') }
    it { expect(VersionRecord::Prerelease.new('.beta')).to       eq    VersionRecord::Prerelease.new('.beta') }
  end
end
