module VersionRecord
  module Macros
    extend ActiveSupport::Concern

    module ClassMethods
      def versioned(column_name: :version)
        VersionRecord::Macros::Versioned.def_versioned(self, column_name)
        VersionRecord::Macros::Versioned.def_by_version(self, column_name)
        VersionRecord::Macros::Versioned.def_latest_version(self, column_name)
      end
    end
  end
end

ActiveSupport.on_load :active_record do
  include VersionRecord::Macros
end
