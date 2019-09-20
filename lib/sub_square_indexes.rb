# frozen_string_literal: true

require_relative 'index_out_of_range_error'

class SubSquareIndexes
  def initialize(square_length)
    @square_length = square_length
  end

  def find(sub_square_index)
    raise IndexOutOfRangeError if sub_square_index > board_length - 1

    (@indexes || {})[sub_square_index] ||= calculate_indexes(sub_square_index)
  end

  private

  attr_reader :square_length

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

  def board_length
    @board_length ||= square_length**2
  end
end
