require 'version_record/version'

class String
  def to_version
    VersionRecord::Version.new(to_s)
  end
end
