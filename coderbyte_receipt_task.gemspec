# frozen_string_literal: true

require_relative "lib/coderbyte_receipt_task/version"

Gem::Specification.new do |spec|
  spec.name = "coderbyte_receipt_task"
  spec.version = CoderbyteReceiptTask::VERSION
  spec.authors = ["Dalvan Gomes"]
  spec.email = ["dalvangsilva@torc.com"]

  spec.summary = "Coder byte Receipt Task"
  spec.description = "Coder byte Receipt Task"
  spec.homepage = "https://torc.coderbyte.com/"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://torc.coderbyte.com/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dalvangsilva/coderbyte_receipt_task"
  spec.metadata["changelog_uri"] = "https://github.com/dalvangsilva/coderbyte_receipt_task"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rspec"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end