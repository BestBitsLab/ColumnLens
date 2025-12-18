# frozen_string_literal: true

require_relative "lib/columnlens/version"

Gem::Specification.new do |spec|
  spec.name = "columnlens"
  spec.version = Columnlens::VERSION
  spec.authors = ["Fai Wong"]
  spec.email = ["wongwf82@gmail.com"]

  spec.summary = "Detect unused, read-only, and orphaned database columns in Rails apps"
  spec.description = <<~DESC
    ColumnLens analyzes your Ruby on Rails codebase and database schema
    to identify actively used, write-only, read-only, and orphaned columns.
    Designed for CI, GitHub Actions, and continuous schema hygiene.
  DESC
  spec.homepage = "https://github.com/BestBitsLab/columnlens"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
