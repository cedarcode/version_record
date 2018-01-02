module VersionRecord
  module Type
    class Version < ActiveRecord::Type::String
      def cast(value)
        value.to_version
      end

      def serialize(value)
        super(value.to_s)
      end
    end
  end
end
