# frozen_string_literal: true

require "yaml"
require_relative "paths"

# Handles loading and merging default and project configurations for ColumnLens
module Columnlens
  class Config
    def self.load
      defaults = load_yaml(Paths.default_config)
      project  = load_yaml(Paths.project_config)

      deep_merge(defaults, project)
    end

    def self.load_yaml(path)
      return {} unless path && File.exist?(path)

      YAML.load_file(path) || {}
    end

    def self.deep_merge(base_config, project_config)
      base_config.merge(project_config) do |_key, old, new|
        old.is_a?(Hash) && new.is_a?(Hash) ? deep_merge(old, new) : new
      end
    end
  end
end
