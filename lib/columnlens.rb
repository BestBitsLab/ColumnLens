# frozen_string_literal: true

require_relative "columnlens/scan_mode"

module Columnlens
  def self.run(args)
    case args.first
    when "scan"
      Columnlens::ScanMode.run
    else
      puts <<~USAGE
        Usage:
          columnlens scan     # Full schema inventory
      USAGE
      exit 1
    end
  end
end
