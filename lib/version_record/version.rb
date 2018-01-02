module VersionRecord
  class Version
    include Comparable

    attr_accessor :major, :minor, :patch

    VERSION_PATTERN = /^(\d+\.)?(\d+\.)?(\d+)$/

    def self.correct?(version)
      !!(version.to_s =~ VERSION_PATTERN)
    end

    def initialize(version)
      @major, @minor, @patch = parse_version(version)
    end

    def to_s
      "#{@major}.#{@minor}.#{@patch}"
    end

    def to_version
      self
    end

    def bump!(segment = :minor)
      send("bump_#{segment}!") if [:major, :minor, :patch].include?(segment)
      self
    end

    def <=>(other)
      if (@major <=> other.major).zero? && (@minor <=> other.minor).zero? && (@patch <=> other.patch).zero?
        0
      elsif (@major <=> other.major).zero? && (@minor <=> other.minor).zero?
        @patch <=> other.patch
      elsif (@major <=> other.major).zero?
        @minor <=> other.minor
      else
        @major <=> other.major
      end
    end

    private

    def parse_version(version)
      unless self.class.correct?(version)
        raise ArgumentError, "Malformed version number string #{version}"
      end

      segments = version.split('.')
      [segments[0].to_i, segments[1].to_i, segments[2].to_i]
    end

    def bump_major!
      @major += 1
      @minor = @patch = 0
    end

    def bump_minor!
      @minor += 1
      @patch = 0
    end

    def bump_patch!
      @patch += 1
    end
  end
end
