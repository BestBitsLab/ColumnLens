# frozen_string_literal: true

module Columnlens
  module Core
    class UsageScanner
      attr_reader :tables, :usage_results

      def initialize(tables)
        # tables: array of { name: "table_name", columns: ["col1", "col2"] }
        @tables = tables
        @usage_results = {}
      end

      def scan!
        tables.each do |table|
          table_name = table[:name]
          columns = table[:columns]

          columns.each do |col|
            status = detect_column_usage(table_name, col)
            mark_used(table_name, col, status)
          end
        end
        usage_results
      end

      private

      # Mark column usage
      def mark_used(table_name, column, status)
        usage_results[table_name] ||= {}
        usage_results[table_name][column] = status
      end

      # Detect usage using multiple heuristics
      def detect_column_usage(table_name, column)
        return :read_write if association_column?(table_name, column)
        return :read_write if scanned_in_code?(table_name, column)

        :orphaned
      end

      # Detect foreign keys for associations
      def association_column?(table_name, column)
        # Common Rails convention: belongs_to :model → model_id
        return true if column =~ /_id$/ && belongs_to_exists?(table_name, column)

        false
      end

      def belongs_to_exists?(table_name, column)
        model_class = table_name.singularize.camelize.safe_constantize
        return false unless model_class.respond_to?(:reflect_on_all_associations)

        model_class.reflect_on_all_associations(:belongs_to).any? do |assoc|
          "#{assoc.name}_id" == column
        end
      rescue NameError
        false
      end

      # Scan Ruby + view templates
      def scanned_in_code?(_table_name, column)
        patterns = [
          "app/models/**/*.rb",
          "app/controllers/**/*.rb",
          "app/jobs/**/*.rb",
          "app/views/**/*.erb",
          "app/views/**/*.slim",
          "app/views/**/*.haml",
          "app/serializers/**/*.rb"
        ]

        patterns.any? do |pattern|
          Dir.glob(pattern).any? do |file|
            File.read(file).include?(column)
          end
        end
      rescue Errno::ENOENT
        false
      end
    end
  end
end
