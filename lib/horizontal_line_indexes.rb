# frozen_string_literal: true

require_relative 'index_out_of_range_error'

class HorizontalLineIndexes
  def initialize(square_length)
    @square_length = square_length
  end

  def find(line_number)
    raise IndexOutOfRangeError if line_number > board_length - 1

    (@indexes || {})[line_number] ||= calculate_indexes(line_number)
  end

  private

  attr_reader :square_length

  def calculate_indexes(line_number)
    board_length.times.map { |index| board_length * line_number + index }
  end

  def board_length
    @board_length ||= square_length**2
  end
end
