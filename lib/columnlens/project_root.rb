# frozen_string_literal: true

module Columnlens
  module ProjectRoot
    def self.detect
      return ENV["GITHUB_WORKSPACE"] if ENV["GITHUB_WORKSPACE"]
      return Rails.root.to_s if defined?(Rails)

      Dir.pwd
    end
  end
end
