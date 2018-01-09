module VersionRecord
  module Type
    class Version < ActiveRecord::Type::String
      def cast(value)
        value.nil? ? super : value.to_version
      end

      def serialize(value)
        value.nil? ? super : super(value.to_s)
      end
    end
  end
end

ActiveRecord::Type.register(:version, VersionRecord::Type::Version)
