module VersionRecord
  class Prerelease
    include Comparable

    def self.build(string)
      new(".#{string}") if string.present?
    end

    def initialize(string)
      @string = string
    end

    def to_s(include_first = true)
      include_first ? @string : @string[1..-1]
    end

    def tail
      @tail ||= self.class.build(at(1..-1).join('.'))
    end

    def first_segment
      @first_segment ||= at(0)
    end

    def <=>(other)
      return unless other.is_a?(Prerelease)

      if first_segment == other.first_segment
        compare_by_tail(other)
      else
        compare_by_first_segment(other)
      end
    end

    private

    def at(index)
      to_a[index]
    end

    def to_a
      to_s(false).split('.')
    end

    def compare_by_tail(other)
      return  1 if self.tail && other.tail.nil?
      return -1 if self.tail.nil? && other.tail
      self.tail <=> other.tail
    end

    def compare_by_first_segment(other)
      if int?(first_segment) && int?(other.first_segment)
        first_segment.to_i <=> other.first_segment.to_i
      else
        first_segment <=> other.first_segment
      end
    end

    def int?(str)
      !!Integer(str)
    rescue ArgumentError, TypeError
      false
    end
  end
end
