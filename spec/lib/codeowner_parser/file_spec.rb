# frozen_string_literal: true

require 'codeowner_parser/file'

RSpec.describe CodeownerParser::File do
  describe '#owner' do
    subject(:code_owner) { described_class.new(file_string).owner(path) }

    context 'with GitHub example' do
      let(:file_string) do
        # Taken from https://help.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners#example-of-a-codeowners-file
        <<~CODEOWNERS
          # This is a comment.
          # Each line is a file pattern followed by one or more owners.

          # These owners will be the default owners for everything in
          # the repo. Unless a later match takes precedence,
          # @global-owner1 and @global-owner2 will be requested for
          # review when someone opens a pull request.
          *       @global-owner1 @global-owner2

          # Order is important; the last matching pattern takes the most
          # precedence. When someone opens a pull request that only
          # modifies JS files, only @js-owner and not the global
          # owner(s) will be requested for a review.
          *.js    @js-owner

          # You can also use email addresses if you prefer. They'll be
          # used to look up users just like we do for commit author
          # emails.
          *.go docs@example.com

          # In this example, @doctocat owns any files in the build/logs
          # directory at the root of the repository and any of its
          # subdirectories.
          /build/logs/ @doctocat

          # The `docs/*` pattern will match files like
          # `docs/getting-started.md` but not further nested files like
          # `docs/build-app/troubleshooting.md`.
          docs/*  docs@example.com

          # In this example, @octocat owns any file in an apps directory
          # anywhere in your repository.
          apps/ @octocat

          # In this example, @doctocat owns any file in the `/docs`
          # directory in the root of your repository.
          /docs/ @doctocat
        CODEOWNERS
      end

      {
        '/blah/blah.js' => ['@js-owner'],
        # Last precedence
        '/hello/docs/blah.js' => ['docs@example.com'],
        # Fallback
        '/blah/blah.json' => ['@global-owner1', '@global-owner2'],
      }.each do |filename, owners|
        context "with '#{filename}'" do
          let(:path) { filename }

          it { is_expected.to eq(owners) }
        end
      end
    end

    context 'with empty fallback' do
      let(:file_string) do
        <<~CODEOWNERS
          # We have no fallback in this file.
          *.js    @js-owner
        CODEOWNERS
      end

      context 'with js file' do
        let(:path) { 'blah.js' }

        it { is_expected.to eq(['@js-owner']) }
      end

      context 'with no match' do
        let(:path) { 'blah.hello' }

        it { is_expected.to eq([]) }
      end
    end
  end
end
