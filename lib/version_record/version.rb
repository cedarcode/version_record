module VersionRecord
  class Version
    include Comparable

    attr_accessor :major, :minor, :patch

    VERSION_PATTERN = /^(\d+)\.(\d+)\.(\d+)(([\.-][0-9A-Za-z-]+)*)$/

    def initialize(version)
      @major, @minor, @patch, @prerelease = parse_version(version)
    end

    def to_s
      "#{@major}.#{@minor}.#{@patch}#{@prerelease}"
    end

    def to_version
      self
    end

    def bump(segment = :minor)
      send("bump_#{segment}") if [:major, :minor, :patch].include?(segment)
      self
    end

    def prerelease
      @prerelease.to_s(false) if @prerelease
    end

    def <=>(other)
      return unless other.respond_to?(:to_version)
      other = other.to_version

      if @major == other.major && @minor == other.minor && @patch == other.patch && @prerelease == other.prerelease
        0
      elsif @major == other.major && @minor == other.minor && @patch == other.patch
        return  1 if @prerelease.nil? && other.prerelease
        return -1 if @prerelease && other.prerelease.nil?

        @prerelease <=> Prerelease.build(other.prerelease)
      elsif @major == other.major && @minor == other.minor
        @patch <=> other.patch
      elsif @major == other.major
        @minor <=> other.minor
      else
        @major <=> other.major
      end
    end

    private

    def parse_version(version)
      unless match = version.to_s.match(VERSION_PATTERN)
        raise ArgumentError, "Malformed version number string #{version}"
      end

      prerelease = Prerelease.new(match[4]) if match[4].present?
      [match[1].to_i, match[2].to_i, match[3].to_i, prerelease]
    end

    def bump_major
      @major += 1
      @minor = @patch = 0
    end

    def bump_minor
      @minor += 1
      @patch = 0
    end

    def bump_patch
      @patch += 1
    end
  end
end
