module VersionRecord
  module Sorting

    # Handles sorting a collection of AR objects.
    #
    # This implementation uses in-memory sorting.
    #
    class Simple
      def initialize(klass, version_column)
        @klass = klass
        @version_column = version_column
      end

      def by_version(direction = :asc)
        collection = @klass.all
        direction.to_sym == :asc ? sort_asc(collection) : sort_desc(collection)
      end

      private

      def sort_asc(collection)
        collection.sort_by { |object| version(object) }
      end

      def sort_desc(collection)
        collection.sort { |obj_1, obj_2| version(obj_2) <=> version(obj_1) }
      end

      def version(object)
        object.public_send(@version_column)
      end
    end
  end
end
