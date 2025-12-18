# frozen_string_literal: true

module Columnlens
  class Classifier
    def self.classify(table, column, usage)
      status =
        case usage
        when :read_write then :active
        when :write_only then :write_only
        when :read_only  then :read_only
        when :orphaned   then :orphaned
        when :system     then :system
        else :unknown
        end

      {
        table: table,
        column: column,
        status: status
      }
    end
  end
end
