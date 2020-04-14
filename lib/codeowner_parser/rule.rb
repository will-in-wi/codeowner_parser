# frozen_string_literal: true

require 'pathname'

module CodeownerParser
  # Handles an individual rule and determines applicability.
  class Rule
    attr_reader :owner

    def initialize(rule_string)
      # It looks like a common denominator is that there are two chunks, each
      # of which contain no spaces.
      @rule_path, @owner = rule_string.split(/\s+/)
      @rule_regex = path_regex
    end

    def applies?(path)
      @rule_regex =~ path
    end

    private

    def path_regex
      literals = @rule_path.split('*', -1)
      regex = ''
      # If path started with a slash, this is rooted.
      regex += '\A' if literals.first.start_with?('/')
      # Join with a wildcard for anything other than a slash.
      regex += literals.map { |literal| Regexp.escape(literal) }.join('[^\/]+')
      # If path did not end with a slash, do not search into subdirectories.
      regex += '\Z' unless literals.last.end_with?('/')

      Regexp.compile(regex)
    end
  end
end
