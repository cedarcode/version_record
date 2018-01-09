module VersionRecord
  class Finder
    def initialize(klass, version_column)
      @klass = klass
      @version_column = version_column
    end

    def find_latest
      by_version.last
    end

    private

    def by_version
      @klass.public_send("by_#{@version_column}")
    end
  end
end
