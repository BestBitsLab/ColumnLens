# frozen_string_literal: true

require_relative "../project_root"

module Columnlens
  module Core
    class SchemaLoader
      TABLE_REGEX  = /create_table "([^"]+)"/
      COLUMN_REGEX = /t\.\w+\s+"([^"]+)"/

      def self.load
        schema_path = File.join(ProjectRoot.detect, "db/schema.rb")

        unless File.exist?(schema_path)
          raise "Columnlens: db/schema.rb not found at #{schema_path}"
        end

        schema_content = File.read(schema_path)
        parse_tables(schema_content)
      end

      def self.parse_tables(schema_content)
        tables = {}
        current_table = nil

        schema_content.each_line do |line|
          if line.match?(TABLE_REGEX)
            current_table = line[TABLE_REGEX, 1]
            tables[current_table] ||= []

          elsif current_table && line.match?(COLUMN_REGEX)
            column = line[COLUMN_REGEX, 1]
            tables[current_table] << column

          elsif line.strip == "end"
            current_table = nil
          end
        end

        tables
      end
    end
  end
end
