# frozen_string_literal: true

class RelatedBoxesFinder
  def initialize(square_length)
    @square_length = square_length
    @indexes = {}
  end

  def find(puzzle, box_type:, index:)
    puzzle.values_at(*indexes_for(box_type, index))
  end

  private

  attr_reader :square_length, :indexes

  def indexes_for(box_type, index)
    (indexes[box_type] ||= {})[index] ||= calculate_indexes_for(box_type, index)
  end

  def calculate_indexes_for(box_type, index)
    case box_type
    when :row then calculate_row_indexes(index)
    when :column then calculate_column_indexes(index)
    when :sub_square then calculate_sub_square_indexes(index)
    end
  end

  def calculate_column_indexes(column_number)
    board_length.times.map { |rows_offset| rows_offset * board_length + column_number }
  end

  def calculate_row_indexes(row_number)
    board_length.times.map { |columns_offset| board_length * row_number + columns_offset }
  end

  def calculate_sub_square_indexes(sub_square_index)
    square_length.times.map do |line_offset|
      starting_index = sub_square_start_index_of(sub_square_index, line_offset)

      (starting_index..starting_index + square_length - 1).to_a
    end.flatten
  end

  def sub_square_start_index_of(sub_square_index, line_offset)
    (sub_square_index - (sub_square_index % square_length) + line_offset) * board_length +
      (sub_square_index % square_length) * square_length
  end

  def board_length
    @board_length ||= square_length**2
  end
end
