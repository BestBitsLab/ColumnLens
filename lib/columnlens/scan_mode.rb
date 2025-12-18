# frozen_string_literal: true

require_relative "core/schema_loader"
require_relative "core/usage_scanner"
require_relative "classifier"
require_relative "config"
require_relative "ignore_rules"
require_relative "result_filter"
require_relative "reporter"

# Handles scanning the database schema and classifying column usage.
module Columnlens
  class ScanMode
    MODE = :scan

    def self.run
      puts "🔍 Columnlens Scan Mode"
      puts "Scanning full schema...\n\n"

      results = process_schema

      Reporter.print(results)
    end

    def self.process_schema
      schema  = Core::SchemaLoader.load
      scanner = Core::UsageScanner.new(map_tables(schema))
      raw     = scanner.scan!

      results = classify_columns(raw)
      filter_results(results)
    end

    def self.map_tables(schema)
      schema.map { |table, columns| { name: table, columns: columns } }
    end

    def self.classify_columns(raw)
      raw.flat_map do |table, columns|
        columns.map do |column, usage|
          Classifier.classify(table, column, usage)
        end
      end
    end

    def self.filter_results(results)
      config = IgnoreRules.new(Config.load)
      ResultFilter.new(config, mode: MODE).filter(results)
    end
  end
end
