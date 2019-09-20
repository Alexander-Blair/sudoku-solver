# frozen_string_literal: true

require_relative 'index_out_of_range_error'
require_relative 'index_finder'

class VerticalLineIndexes
  include IndexFinder

  def calculate_indexes(column_number)
    board_length.times.map do |rows_offset|
      rows_offset * board_length + column_number
    end
  end
end
