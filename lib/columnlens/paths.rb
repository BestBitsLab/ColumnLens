# frozen_string_literal: true

module Columnlens
  module Paths
    def self.project_root
      ProjectRoot.detect
    end

    def self.project_config
      File.join(project_root, ".columnlens.yml")
    end

    def self.default_config
      File.expand_path("../columnlens/config/default.yml", __dir__)
    end
  end
end
