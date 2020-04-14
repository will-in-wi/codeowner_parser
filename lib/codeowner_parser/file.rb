# frozen_string_literal: true

require 'codeowner_parser/rule'

module CodeownerParser
  # Parses an entire codeowners file.
  class File
    def initialize(file_string)
      @file_string = file_string

      raise ArgumentError, 'CODEOWNER file cannot be nil' if @file_string.nil?

      # Precompute for repeated access. Reverse because of reverse precedence.
      @rules = rules.reverse
    end

    def owner(path)
      applicative_rule = @rules.find { |rule| rule.applies?(path) }
      return [] if applicative_rule.nil?

      applicative_rule.owner
    end

    private

    def rules
      @file_string.split("\n").inject([]) do |memo, line|
        # Delete everything after a comment.
        line, = line.split('#')
        line = (line || '').strip
        next memo if line == ''

        memo << Rule.new(line)
      end
    end
  end
end
