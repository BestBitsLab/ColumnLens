# frozen_string_literal: true

require_relative "core/schema_loader"
require_relative "core/usage_scanner"
require_relative "classifier"
require_relative "config"
require_relative "ignore_rules"
require_relative "result_filter"
require_relative "reporter"

module Columnlens
  class ScanMode
    MODE = :scan

    def self.run
      puts "🔍 Columnlens Scan Mode"
      puts "Scanning full schema...\n\n"

      schema = Core::SchemaLoader.load

      scanner = Core::UsageScanner.new(
        schema.map { |table, columns| { name: table, columns: columns } }
      )

      raw = scanner.scan!

      results = raw.flat_map do |table, columns|
        columns.map do |column, usage|
          Classifier.classify(table, column, usage)
        end
      end

      config  = IgnoreRules.new(Config.load)
      results = ResultFilter.new(config, mode: MODE).filter(results)

      Reporter.print(results)
    end
  end
end
