# frozen_string_literal: true

module Columnlens
  class IgnoreRules
    def initialize(config)
      @config = config
    end

    def system_table_patterns
      Array(@config["system_tables"]).map { |p| Regexp.new(p) }
    end

    def ignored?(mode:, category:, table:, column:)
      entries = Array(
        @config.dig("ignore", mode.to_s, category.to_s)
      )

      entries.any? do |e|
        e == table || e == "#{table}.#{column}"
      end
    end
  end
end
