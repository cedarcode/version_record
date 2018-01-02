describe VersionRecord::Type::Version do
  subject(:version_type) { VersionRecord::Type::Version.new }

  it { is_expected.to be_an ActiveRecord::Type::String }

  describe '#cast' do
    it { expect(version_type.cast('1.1.2')).to eq VersionRecord::Version.new('1.1.2') }
    it { expect { version_type.cast('1.1.2.') }.to raise_error ArgumentError }
  end

  describe '#serialize' do
    it { expect(version_type.serialize(VersionRecord::Version.new('1.1.2'))).to eq '1.1.2' }
  end
end
