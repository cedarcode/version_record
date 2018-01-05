module VersionRecord
  class Version
    include Comparable

    attr_accessor :major, :minor, :patch

    def initialize(version)
      @major, @minor, @patch, @prerelease = Parser.new(version.to_s).parse
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

      if same_segments?(other, :major, :minor, :patch, :prerelease)
        0
      elsif same_segments?(other, :major, :minor, :patch)
        compare_by(other, :prerelease)
      elsif same_segments?(other, :major, :minor)
        compare_by(other, :patch)
      elsif same_segments?(other, :major)
        compare_by(other, :minor)
      else
        compare_by(other, :major)
      end
    end

    private

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

    # Checks if all the segments in other are equal to the ones passed as a
    # parameter.
    #
    # For example, calling same_segments?(other, :major, :minor) will check:
    #
    #    self.major == other.major && self.minor == other.minor
    #
    def same_segments?(other, *segments)
      segments.all? { |segment| send(segment) == other.send(segment) }
    end

    def compare_by(other, segment)
      if [:major, :minor, :patch].include?(segment)
        send(segment) <=> other.send(segment)
      else
        compare_by_prerelease(other)
      end
    end

    def compare_by_prerelease(other)
      return  1 if @prerelease.nil? && other.prerelease
      return -1 if @prerelease && other.prerelease.nil?

      @prerelease <=> Prerelease.build(other.prerelease)
    end

    class Parser
      VERSION_PATTERN = /^(\d+)\.(\d+)\.(\d+)(([\.-][0-9A-Za-z-]+)*)$/

      def initialize(version)
        @version = version
      end

      def parse
        error! unless match = @version.match(VERSION_PATTERN)
        prerelease = Prerelease.new(match[4]) if match[4].present?

        [match[1].to_i, match[2].to_i, match[3].to_i, prerelease]
      end

      private

      def error!
        raise ArgumentError, "Malformed version number string #{@version}"
      end
    end
  end
end
