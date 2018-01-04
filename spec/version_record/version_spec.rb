describe VersionRecord::Version do

  subject(:version) { VersionRecord::Version.new('1.1.2') }

  describe '.new' do
    context 'only major' do
      let(:version) { VersionRecord::Version.new('2') }

      it { expect(version.major).to eq 2 }
      it { expect(version.minor).to eq 0 }
      it { expect(version.patch).to eq 0 }
    end

    context 'only major and minor' do
      let(:version) { VersionRecord::Version.new('2.3') }

      it { expect(version.major).to eq 2 }
      it { expect(version.minor).to eq 3 }
      it { expect(version.patch).to eq 0 }
    end

    context 'major, minor and patch' do
      let(:version) { VersionRecord::Version.new('2.3.1') }

      it { expect(version.major).to eq 2 }
      it { expect(version.minor).to eq 3 }
      it { expect(version.patch).to eq 1 }
    end

    context 'unsupported format' do
      it { expect { VersionRecord::Version.new('2..1') }.to   raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('2.') }.to     raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('.1') }.to     raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('fdsdfa') }.to raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('2.x.1') }.to  raise_error(ArgumentError) }
    end
  end

  describe '#to_s' do
    let(:version) { VersionRecord::Version.new('1.1.0') }
    it { expect(version.to_s).to eq '1.1.0' }
  end

  describe '#bump' do
    context 'bump major' do
      it { expect(version.bump(:major).to_s).to eq '2.0.0' }
    end

    context 'bump minor' do
      it { expect(version.bump(:minor).to_s).to eq '1.2.0' }
      it { expect(version.bump.to_s).to eq '1.2.0' }
    end

    context 'bump patch' do
      it { expect(version.bump(:patch).to_s).to eq '1.1.3' }
    end
  end

  describe '#comparison' do
    it { expect(VersionRecord::Version.new('2.1.3')).to be >  VersionRecord::Version.new('2.1.0') }
    it { expect(VersionRecord::Version.new('2.1.3')).to eq    VersionRecord::Version.new('2.1.3') }
    it { expect(VersionRecord::Version.new('2.1.3')).to be >= VersionRecord::Version.new('2.1.3') }
    it { expect(VersionRecord::Version.new('2.2.3')).to be >  VersionRecord::Version.new('2.1.2') }
    it { expect(VersionRecord::Version.new('2.2.0')).to be >  VersionRecord::Version.new('2.1.3') }
    it { expect(VersionRecord::Version.new('3.2.0')).to be >  VersionRecord::Version.new('2.1.3') }
    it { expect(VersionRecord::Version.new('3.0.0')).to be >  VersionRecord::Version.new('2.1.3') }
    it { expect(VersionRecord::Version.new('3.1.1')).to be >  VersionRecord::Version.new('2.1.1') }
    it { expect(VersionRecord::Version.new('3.1.3')).to be >  VersionRecord::Version.new('2.5.5') }
    it { expect(VersionRecord::Version.new('3.1.0')).to be >  VersionRecord::Version.new('3.0.0') }
    it { expect(VersionRecord::Version.new('3.1.0')).not_to eq nil }
  end

  describe '#to_version' do
    it { expect(version.to_version).to eq version }
  end
end
