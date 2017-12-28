$:.push File.expand_path('../lib', __FILE__)
require 'version_record/gem_version'

Gem::Specification.new do |s|
  s.name        = 'version_record'
  s.version     = VersionRecord::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.date        = '2017-12-28'
  s.summary     = 'Tools for managing versioned records in ActiveRecord'
  s.authors     = ['Marcelo Casiraghi']
  s.email       = 'marcelo@cedarcode.com'
  s.homepage    = 'https://github.com/cedarcode/version_record'
  s.license     = 'MIT'

  s.files         = `git ls-files -- lib/*`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")

  s.add_development_dependency 'bundler', '~> 1'
end
