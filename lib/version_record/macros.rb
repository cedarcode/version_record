module VersionRecord
  module Macros
    extend ActiveSupport::Concern

    module ClassMethods
      def versioned
        VersionRecord::Macros::Versioned.def_versioned(self)
      end
    end
  end
end

ActiveSupport.on_load :active_record do
  include VersionRecord::Macros
end
