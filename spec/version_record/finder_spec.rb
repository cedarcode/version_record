describe VersionRecord::Finder do
  describe "#find_latest" do
    subject(:finder) { VersionRecord::Finder.new(Document, :version) }

    before do
      create_table(:documents) do |t|
        t.string :title
        t.string :version
      end

      spawn_model(:Document) do
        versioned
      end
    end

    context 'when data exists' do
      before do
        @document_1 = Document.create!(title: 'Title 1', version: '1.1.0')
        @document_2 = Document.create!(title: 'Title 2', version: '1.0.0')
        @document_3 = Document.create!(title: 'Title 3', version: '1.1.1')
      end

      it { expect(finder.find_latest).to eq @document_3 }
    end

    context 'with no data' do
      it { expect(finder.find_latest).to be_nil }
    end
  end
end
