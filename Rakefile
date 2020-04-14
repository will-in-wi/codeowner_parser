# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rubocop/rake_task'
desc 'Run Rubocop'
RuboCop::RakeTask.new(:rubocop)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: %i[rubocop spec]
