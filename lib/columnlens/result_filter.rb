# frozen_string_literal: true

module Columnlens
  class ResultFilter
    def initialize(config, mode:)
      @config = config
      @mode   = mode
    end

    def filter(results)
      results.reject do |r|
        system_table?(r[:table]) ||
          ignored?(r)
      end
    end

    private

    def system_table?(table)
      @config.system_table_patterns.any? { |p| table.match?(p) }
    end

    def ignored?(record)
      @config.ignored?(
        mode: @mode,
        category: record[:status],
        table: record[:table],
        column: record[:column]
      )
    end
  end
end
