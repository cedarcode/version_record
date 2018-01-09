describe VersionRecord::Sorting::Simple do
  describe "#by_version" do
    subject(:sorting_strategy) { VersionRecord::Sorting::Simple.new(Document, :version) }

    before do
      create_table(:documents) do |t|
        t.string :title
        t.string :version
      end

      spawn_model(:Document) do
        versioned
      end

      @document_1 = Document.create!(title: 'Title 1', version: '1.1.0')
      @document_2 = Document.create!(title: 'Title 2', version: '1.0.0')
      @document_3 = Document.create!(title: 'Title 3', version: '1.1.1')
    end

    it { expect(sorting_strategy.by_version).to        eq [@document_2, @document_1, @document_3] }
    it { expect(sorting_strategy.by_version(:asc)).to  eq [@document_2, @document_1, @document_3] }
    it { expect(sorting_strategy.by_version(:desc)).to eq [@document_3, @document_1, @document_2] }
  end
end
