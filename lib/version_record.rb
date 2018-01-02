require 'version_record/version'
require 'version_record/type/version'
require 'version_record/macros/versioned'
require 'version_record/macros'

class String
  def to_version
    VersionRecord::Version.new(to_s)
  end
end

ActiveRecord::Type.register(:version, VersionRecord::Type::Version)
