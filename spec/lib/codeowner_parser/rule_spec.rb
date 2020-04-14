# frozen_string_literal: true

require 'codeowner_parser/rule'

RSpec::Matchers.define :apply_to do |expected|
  match do |rule|
    rule.applies?(expected)
  end
end

RSpec::Matchers.define :have_owner do |expected|
  match do |rule|
    rule.owner == expected
  end
end

RSpec.describe CodeownerParser::Rule do
  subject(:rule) { described_class.new(rule_string) }

  # Initial examples come from https://help.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners
  context 'with js extension and group owner' do
    let(:rule_string) { '*.js    @js-owner' }

    it { is_expected.to apply_to('blah.js') }
    it { is_expected.not_to apply_to('blah.rb') }
    it { is_expected.to have_owner('@js-owner') }
  end

  context 'with go extension and email owner' do
    let(:rule_string) { '*.go docs@example.com' }

    it { is_expected.to apply_to('blah.go') }
    it { is_expected.not_to apply_to('blah.rb') }
    it { is_expected.to have_owner('docs@example.com') }
  end

  context 'with entire specific folder' do
    let(:rule_string) { '/build/logs/ @doctocat' }

    it { is_expected.to apply_to('/build/logs/blah.go') }
    it { is_expected.not_to apply_to('/logs/blah.go') }
    it { is_expected.not_to apply_to('/tmp/build/logs/blah.go') }
    it { is_expected.not_to apply_to('blah.rb') }
    it { is_expected.to have_owner('@doctocat') }
  end

  context 'with entire rooted folder structure' do
    let(:rule_string) { '/build/logs/ @doctocat' }

    it { is_expected.to apply_to('/build/logs/blah.go') }
    it { is_expected.to apply_to('/build/logs/other/blah.go') }
    it { is_expected.not_to apply_to('/logs/blah.go') }
    it { is_expected.not_to apply_to('/tmp/build/logs/blah.go') }
    it { is_expected.not_to apply_to('blah.rb') }
    it { is_expected.to have_owner('@doctocat') }
  end

  context 'with specific unrooted folder' do
    let(:rule_string) { 'docs/*  docs@example.com' }

    it { is_expected.to apply_to('/build/docs/blah.go') }
    it { is_expected.to apply_to('docs/blah.go') }
    it { is_expected.not_to apply_to('docs/tmp/blah.go') }
    it { is_expected.not_to apply_to('/build/docs/other/blah.go') }
    it { is_expected.not_to apply_to('/logs/blah.go') }
    it { is_expected.not_to apply_to('blah.rb') }
    it { is_expected.to have_owner('docs@example.com') }
  end

  context 'with entire unrooted folder' do
    let(:rule_string) { 'apps/ @octocat' }

    it { is_expected.to apply_to('apps/blah.go') }
    it { is_expected.to apply_to('apps/blah/blah.go') }
    it { is_expected.to apply_to('/apps/blah/blah.go') }
    it { is_expected.not_to apply_to('/logs/blah.go') }
    it { is_expected.not_to apply_to('blah.rb') }
    it { is_expected.to have_owner('@octocat') }
  end

  context 'with entire rooted folder' do
    let(:rule_string) { '/docs/ @doctocat' }

    it { is_expected.to apply_to('/docs/blah.go') }
    it { is_expected.to apply_to('/docs/blah/blah.go') }
    it { is_expected.not_to apply_to('/help/docs/blah.go') }
    it { is_expected.not_to apply_to('/logs/blah.go') }
    it { is_expected.not_to apply_to('blah.rb') }
    it { is_expected.to have_owner('@doctocat') }
  end
end
