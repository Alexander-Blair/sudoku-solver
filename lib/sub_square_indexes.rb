# frozen_string_literal: true

require_relative 'index_out_of_range_error'
require_relative 'index_finder'

class SubSquareIndexes
  include IndexFinder

  def calculate_indexes(sub_square_index)
    square_length.times.map do |line_offset|
      starting_index = starting_index_of(sub_square_index, line_offset)

      (starting_index..starting_index + square_length - 1).to_a
    end.flatten
  end

  def starting_index_of(sub_square_index, line_offset)
    (sub_square_index - (sub_square_index % square_length) + line_offset) * board_length +
      (sub_square_index % square_length) * square_length
  end
end
