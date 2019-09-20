# frozen_string_literal: true

require_relative 'index_out_of_range_error'
require_relative 'index_finder'

class HorizontalLineIndexes
  include IndexFinder

  def calculate_indexes(row_number)
    board_length.times.map do |columns_offset|
      board_length * row_number + columns_offset
    end
  end
end
