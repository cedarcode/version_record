module VersionRecord
  module Macros
    class Versioned

      class << self

        def def_versioned(klass)
          version_column = :version
          klass.attribute version_column, :version
        end
      end
    end
  end
end
