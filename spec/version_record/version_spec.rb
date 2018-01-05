describe VersionRecord::Version do

  subject(:version) { VersionRecord::Version.new('1.1.2') }

  describe '.new' do
    context '2.3.1' do
      let(:version) { VersionRecord::Version.new('2.3.1') }

      it { expect(version.major).to eq 2 }
      it { expect(version.minor).to eq 3 }
      it { expect(version.patch).to eq 1 }
      it { expect(version.prerelease).to be_nil }
    end

    context '1.0.0-alpha' do
      let (:version) { VersionRecord::Version.new('1.0.0-alpha') }

      it { expect(version.major).to eq 1 }
      it { expect(version.minor).to eq 0 }
      it { expect(version.patch).to eq 0 }
      it { expect(version.prerelease).to eq 'alpha' }
    end

    context '1.0.0.alpha' do
      let (:version) { VersionRecord::Version.new('1.0.0.alpha') }

      it { expect(version.major).to eq 1 }
      it { expect(version.minor).to eq 0 }
      it { expect(version.patch).to eq 0 }
      it { expect(version.prerelease).to eq 'alpha' }
    end

    context '1.0.0-alpha.1' do
      let (:version) { VersionRecord::Version.new('1.0.0-alpha.1') }

      it { expect(version.major).to eq 1 }
      it { expect(version.minor).to eq 0 }
      it { expect(version.patch).to eq 0 }
      it { expect(version.prerelease).to eq 'alpha.1' }
    end

    context '1.0.0.alpha.1' do
      let (:version) { VersionRecord::Version.new('1.0.0.alpha.1') }

      it { expect(version.major).to eq 1 }
      it { expect(version.minor).to eq 0 }
      it { expect(version.patch).to eq 0 }
      it { expect(version.prerelease).to eq 'alpha.1' }
    end

    context '1.0.0-alpha.beta' do
      let (:version) { VersionRecord::Version.new('1.0.0-alpha.beta') }

      it { expect(version.major).to eq 1 }
      it { expect(version.minor).to eq 0 }
      it { expect(version.patch).to eq 0 }
      it { expect(version.prerelease).to eq 'alpha.beta' }
    end

    context '1.0.0.alpha.beta' do
      let (:version) { VersionRecord::Version.new('1.0.0.alpha.beta') }

      it { expect(version.major).to eq 1 }
      it { expect(version.minor).to eq 0 }
      it { expect(version.patch).to eq 0 }
      it { expect(version.prerelease).to eq 'alpha.beta' }
    end

    context '1.0.0-beta.11' do
      let (:version) { VersionRecord::Version.new('1.0.0-beta.11') }

      it { expect(version.major).to eq 1 }
      it { expect(version.minor).to eq 0 }
      it { expect(version.patch).to eq 0 }
      it { expect(version.prerelease).to eq 'beta.11' }
    end

    context '1.0.0.beta.11' do
      let (:version) { VersionRecord::Version.new('1.0.0.beta.11') }

      it { expect(version.major).to eq 1 }
      it { expect(version.minor).to eq 0 }
      it { expect(version.patch).to eq 0 }
      it { expect(version.prerelease).to eq 'beta.11' }
    end

    context 'unsupported format' do
      it { expect { VersionRecord::Version.new('2') }.to      raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('2.1') }.to    raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('2..1') }.to   raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('2.') }.to     raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('.1') }.to     raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('fdsdfa') }.to raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('2.x.1') }.to  raise_error(ArgumentError) }
      it { expect { VersionRecord::Version.new('a.b.c') }.to  raise_error(ArgumentError) }
    end
  end

  describe '#to_s' do
    context 'without prerelease' do
      let(:version) { VersionRecord::Version.new('1.1.0') }
      it { expect(version.to_s).to eq '1.1.0' }
    end

    context 'with prerelease' do
      let(:version) { VersionRecord::Version.new('1.1.0.rc1') }
      it { expect(version.to_s).to eq '1.1.0.rc1' }
    end
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
    it { expect(VersionRecord::Version.new('3.1.0')).to eq   '3.1.0' }
    it { expect(VersionRecord::Version.new('3.1.0')).to be > '3.0.0' }
  end

  describe '#to_version' do
    it { expect(version.to_version).to eq version }
  end
end
