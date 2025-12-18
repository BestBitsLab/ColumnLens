# frozen_string_literal: true

module Columnlens
  class Reporter
    ICONS = {
      active: "🟢",
      write_only: "🟡",
      read_only: "🟠",
      orphaned: "🔴"
    }.freeze

    def self.print(results)
      grouped = results.group_by { |r| r[:status] }

      grouped.each do |status, items|
        puts "\n#{ICONS[status]} #{status.to_s.upcase} (#{items.count})"
        items.each do |r|
          puts "  - #{r[:table]}.#{r[:column]}"
        end
      end
    end
  end
end
