# frozen_string_literal: true

require 'codeowner_parser/version'
require 'codeowner_parser/file'

# A parser for CODEOWNER files.
module CodeownerParser
  class Error < StandardError; end

  def self.parse(file)
    CodeownerParser::File.new(file)
  end
end
