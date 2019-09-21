# frozen_string_literal: true

module Models
  class RowIndexes
    include IndexFinder

    private

    def calculate_indexes(row_number)
      board_length.times.map do |columns_offset|
        board_length * row_number + columns_offset
      end
    end
  end
end
