require 'version_record/finder'
require 'version_record/macros'
require 'version_record/prerelease'
require 'version_record/version'
require 'version_record/macros/versioned'
require 'version_record/sorting/simple'
require 'version_record/type/version'

class String
  def to_version
    VersionRecord::Version.new(to_s)
  end
end

ActiveRecord::Type.register(:version, VersionRecord::Type::Version)
