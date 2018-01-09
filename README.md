# version_record

[![Build Status](https://travis-ci.org/cedarcode/version_record.svg?branch=master)](https://travis-ci.org/cedarcode/version_record)
[![Code Climate](https://codeclimate.com/github/cedarcode/version_record/badges/gpa.svg)](https://codeclimate.com/github/cedarcode/version_record)
[![Gem Version](https://badge.fury.io/rb/version_record.svg)](https://badge.fury.io/rb/version_record)

version_record provides a handful of tools to make versioning
 support super straight forward when it needs to be done at
 the database level. It makes use of ActiveRecord serialization
 and querying facilities to provide a nice API when dealing
 with versions. It relies heavily on [Semantic Versioning](https://semver.org/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'version_record'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install version_record

## Usage

The more straight forward use case for this gem would be for
 an application implementing versioning at the database level. Let's
 say your application has a `documents` table for storing legal
 documents, which has a `version` column for storing the document
 version. Then you could do something like this:

```ruby
class Document < ActiveRecord::Base
  versioned
end
```

This will generate the following behavior:

```ruby
document = Document.new(version: '2.0.0')
document.version              # => #<VersionRecord::Version:0x007fd171d5c8f8 @major=2, @minor=0, @patch=0, @prerelease=nil>

document.version.to_s         # => "2.0.0"
document.version.bump         # => "2.1.0"
document.version.bump(:major) # => "3.0.0"
document.version.bump(:patch) # => "3.0.1"
document.save!
```

It will also generate two helper methods in your model called
 `by_version` and `latest_version`

```ruby
Document.where(title: 'Terms of service').by_version(:desc) # => Will return a sorted list of "Terms of service" documents, ordered by version
Document.where(title: 'Terms of service').latest_version    # => Will return the latest "Terms of service" document
```

**WARNING**: `by_version` and `latest_version` are for now considered
 inefficient and you should be careful about using them with
 large sets of data. They use in-memory sorting, please use them
 at your own risk.

### Storing versions
Versions are treated seamlessly as normal attributes

```ruby
Document.create!(version: '1.0.0')
```

Or you can use setters on objects:
```ruby
document.version = "1.0.0.beta"
document.version.to_s # => "1.0.0.beta"
```

### Comparing versions
Version comparison work as you'd expect, honoring
 the [Semantic Versioning](https://semver.org/#semantic-versioning-specification-semver)
 specification:

```ruby
document_1 = Document.create!(version: '1.0.0')
document_2 = Document.create!(version: '1.1.0')
document_3 = Document.create!(version: '1.1.1.beta')
document_4 = Document.create!(version: '1.1.1')

document_1.version.class                # => VersionRecord::Version
document_1.version < document_2.version # => true
document_2.version < document_3.version # => true
document_3.version < document_4.version # => true
```

### Querying
ActiveRecord-style querying is supported. Versions are stored
as strings in the end, so you can still use normal querying:

```ruby
Document.where(version: '1.0.0')  # => Returns all the documents with version "1.0.0"
Document.find_by_version('2.0.0') # => Finds the document with version "2.0.0"
```

However, if you need to deal with version objects, this should
also work:

```ruby
document = Document.create!(version: '1.0.0') # => VersionRecord::Version
Document.where(version: document.version)     # => Returns all the documents with version "1.0.0"
Document.find_by_version(document.version)    # => Finds the document with version "1.0.0"
```

### String#to_version
version_record adds a handy helper for strings:
```ruby
"1.0.0".to_version     # => #<VersionRecord::Version:0x007fd17191bca8...
"1.0.0-rc1".to_version # => #<VersionRecord::Version:0x007fd17191bca8...
"1...1".to_version     # => ArgumentError: Malformed version number string 1...1
```

### Custom options

If your version column is not called `version` you can
 customize it with the `column_name` option. For example,
 let's say that the name of your column is `semantic_version`
 instead of `version`, then you can do:

```ruby
class Document < ActiveRecord::Base
  versioned column_name: :semantic_version
end
```

So then calling `document.semantic_version` should properly
 respond with a version object:

```ruby
document.semantic_version # => #<VersionRecord::Version:0x007fd171d5c8f8 @major=2, @minor=0, @patch=0, @prerelease=nil>
```

## Contributing

1. Fork it ( https://github.com/cedarcode/version_record/ )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

See the [Running Tests](RUNNING_TESTS.md) guide for details on how to run the test suite.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
