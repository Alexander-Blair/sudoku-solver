# frozen_string_literal: true

module Models
  class ColumnIndexes
    include IndexFinder

    private

    def calculate_indexes(column_number)
      board_length.times.map do |rows_offset|
        rows_offset * board_length + column_number
      end
    end
  end
end
