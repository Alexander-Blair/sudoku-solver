# frozen_string_literal: true

class RelatedBoxesFinder
  def initialize(square_length)
    @square_length = square_length
  end

  def find_row_boxes_from(current_branch, row_number)
    box_indexes = row_indexes_for(row_number)

    current_branch.values_at(*box_indexes)
  end

  def find_column_boxes_from(current_branch, column_number)
    box_indexes = column_indexes_for(column_number)

    current_branch.values_at(*box_indexes)
  end

  def find_sub_square_boxes_from(current_branch, sub_square_index)
    box_indexes = sub_square_indexes_for(sub_square_index)

    current_branch.values_at(*box_indexes)
  end

  private

  attr_reader :square_length

  def row_indexes_for(row_number)
    (@row_indexes_finder ||= Models::RowIndexes.new(square_length)).find(row_number)
  end

  def column_indexes_for(column_number)
    (@column_indexes_finder ||= Models::ColumnIndexes.new(square_length)).find(column_number)
  end

  def sub_square_indexes_for(sub_square_index)
    (@sub_square_indexes_finder ||= Models::SubSquareIndexes.new(square_length))
      .find(sub_square_index)
  end
end
