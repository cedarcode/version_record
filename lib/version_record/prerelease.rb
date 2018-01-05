module VersionRecord
  class Prerelease
    def initialize(string)
      @string = string
    end

    def to_s
      @string
    end
  end
end
