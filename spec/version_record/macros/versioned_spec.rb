describe VersionRecord::Macros::Versioned do

  describe '#versioned' do
    before do
      create_table(:documents) do |t|
        t.string :title
        t.string :version
      end

      spawn_model(:Document) do
        versioned
      end
    end

    context 'reading attribute' do
      context 'when version column has values' do
        let(:document) { Document.create!(title: 'Terms of service', version: '1.0.0') }
        it { expect(document.version).to eq VersionRecord::Version.new('1.0.0') }
      end

      context 'when version column is nil' do
        let(:document) { Document.create!(title: 'Terms of service', version: nil) }
        it { expect(document.version).to be_nil }
      end
    end

    context 'setting new values' do
      context 'when version column has values' do
        let(:document) { Document.create!(title: 'Terms of service', version: '1.0.0') }

        it 'should accept a string' do
          document.version = '1.1.0'
          expect(document.version).to eq VersionRecord::Version.new('1.1.0')
        end

        it 'should accept a Version object' do
          document.version = VersionRecord::Version.new('1.1.0')
          expect(document.version).to eq VersionRecord::Version.new('1.1.0')
        end

        it 'should save to db with a string' do
          document.update(version: '1.1.0')
          expect(document.reload.version).to eq VersionRecord::Version.new('1.1.0')
        end

        it 'should save to db with a Version object' do
          document.update(version: VersionRecord::Version.new('1.1.0'))
          expect(document.reload.version).to eq VersionRecord::Version.new('1.1.0')
        end

        it 'should raise if malformed version' do
          expect { document.update(version: '1.1.1.') }.to raise_error(ArgumentError)
          expect(document.reload.version).to eq VersionRecord::Version.new('1.0.0')
        end

        it 'should allow setting the version to nil' do
          document.version = nil
          document.save!
          expect(document.reload.version).to be_nil
        end
      end

      context 'when version column is nil' do
        let(:document) { Document.create!(title: 'Terms of service', version: nil) }

        it 'should accept a string' do
          document.version = '1.1.0'
          expect(document.version).to eq VersionRecord::Version.new('1.1.0')
        end

        it 'should accept a Version object' do
          document.version = VersionRecord::Version.new('1.1.0')
          expect(document.version).to eq VersionRecord::Version.new('1.1.0')
        end

        it 'should save to db with a string' do
          document.update(version: '1.1.0')
          expect(document.reload.version).to eq VersionRecord::Version.new('1.1.0')
        end

        it 'should save to db with a Version object' do
          document.update(version: VersionRecord::Version.new('1.1.0'))
          expect(document.reload.version).to eq VersionRecord::Version.new('1.1.0')
        end

        it 'should raise if malformed version' do
          expect { document.update(version: '1.1.1.') }.to raise_error(ArgumentError)
          expect(document.reload.version).to be_nil
        end

        it 'should allow setting the version to nil' do
          document.version = nil
          document.save!
          expect(document.reload.version).to be_nil
        end
      end
    end

    context 'querying' do
      let!(:document_1) { Document.create!(title: 'Terms of service', version: '1.0.0') }
      let!(:document_2) { Document.create!(title: 'Terms of service', version: '1.1.0') }
      let!(:document_3) { Document.create!(title: 'Terms of service', version: '1.1.1') }
      let!(:document_4) { Document.create!(title: 'Terms of service', version: nil) }

      it { expect(Document.where(version: '1.1.1')).to eq [document_3] }
      it { expect(Document.where(version: VersionRecord::Version.new('1.1.1'))).to eq [document_3] }
      it { expect(Document.where(version: nil)).to eq [document_4] }
    end
  end
end
