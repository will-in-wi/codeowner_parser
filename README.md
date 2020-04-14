# CodeownerParser

The goal of this gem is primarily to parse a CODEOWNER file and return the team associated with a file given the file path.

An ancillary goal is to allow you to route errors to a different team by file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'codeowner_parser'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install codeowner_parser

## Usage

See [GitHub's documentation](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners#example-of-a-codeowners-file) for examples of codeowner files.

```ruby
require 'codeowner_parser'

str = <<~CODEOWNERS
*       @global-owner1 @global-owner2
*.js    @js-owner
*.go docs@example.com
/build/logs/ @doctocat
docs/*  docs@example.com
apps/ @octocat
/docs/ @doctocat
CODEOWNERS

parser = CodeownerParser.parse(str)
parser.owner('/build/docs/blah.json')
# => docs@example.com
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/will-in-wi/codeowner_parser.
