$:.push File.expand_path('../lib', __FILE__)
require 'version_record/gem_version'

Gem::Specification.new do |s|
  s.name        = 'version_record'
  s.version     = VersionRecord::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.date        = '2017-12-28'
  s.summary     = 'Semantic version management for database records using ActiveRecord'
  s.authors     = ['Marcelo Casiraghi']
  s.email       = 'marcelo@cedarcode.com'
  s.homepage    = 'https://github.com/cedarcode/version_record'
  s.license     = 'MIT'

  s.files         = `git ls-files -- lib/*`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'activesupport', '~> 5'
  s.add_dependency 'activerecord',  '~> 5'

  s.add_development_dependency 'bundler', '~> 1'
  s.add_development_dependency 'byebug', '~> 9'
  s.add_development_dependency 'rspec-rails', '~> 3'
  s.add_development_dependency 'sqlite3', '~> 1'
  s.add_development_dependency 'rails', '~> 5'
  s.add_development_dependency 'appraisal', '~> 2'
end
