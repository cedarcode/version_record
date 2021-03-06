module VersionRecord
  module Macros
    class Versioned

      class << self

        def def_versioned(klass, version_column)
          klass.attribute version_column, :version
        end

        def def_by_version(klass, version_column)
          klass.define_singleton_method("by_#{version_column}") do |direction = :asc|
            Sorting::Simple.new(klass, version_column).by_version(direction)
          end
        end

        def def_latest_version(klass, version_column)
          klass.define_singleton_method("latest_#{version_column}") do
            Finder.new(klass, version_column).find_latest
          end
        end
      end
    end
  end
end
