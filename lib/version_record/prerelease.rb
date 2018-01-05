module VersionRecord
  class Prerelease
    include Comparable

    def self.build(string)
      new(".#{string}")
    end

    def initialize(string)
      @string = string
    end

    def to_s(include_first = true)
      include_first ? @string : @string[1..-1]
    end

    def tail
      str = to_a[1..-1].join('.')
      self.class.new(".#{str}") if str.present?
    end

    def at(index)
      to_a[index]
    end

    def <=>(other)
      return unless other.is_a?(Prerelease)
      segment       = self.at(0)
      other_segment = other.at(0)

      if segment == other_segment
        return  1 if self.at(1) && other.at(1).nil?
        return -1 if self.at(1).nil? && other.at(1)
        self.tail <=> other.tail
      else
        if int?(segment) && int?(other_segment)
          segment.to_i <=> other_segment.to_i
        else
          segment <=> other_segment
        end
      end
    end

    private

    def to_a
      to_s(false).split('.')
    end

    def int?(str)
      !!Integer(str)
    rescue ArgumentError, TypeError
      false
    end
  end
end
