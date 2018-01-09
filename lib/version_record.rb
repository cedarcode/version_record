require 'version_record/finder'
require 'version_record/macros'
require 'version_record/prerelease'
require 'version_record/version'
require 'version_record/macros/versioned'
require 'version_record/sorting/simple'
require 'version_record/type/version'
require 'version_record/core_ext/string'

ActiveRecord::Type.register(:version, VersionRecord::Type::Version)
