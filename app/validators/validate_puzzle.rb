# frozen_string_literal: true

module Validators
  class ValidatePuzzle
    NoPossibleValuesFoundError = Class.new(StandardError)
    DuplicatedValuesError = Class.new(StandardError)

    def self.call(puzzle:, square_length:, related_boxes_finder:)
      new(puzzle, square_length, related_boxes_finder).call
    end

    def initialize(puzzle, square_length, related_boxes_finder)
      @puzzle = puzzle
      @square_length = square_length
      @related_boxes_finder = related_boxes_finder
    end

    def call
      raise NoPossibleValuesFoundError if puzzle.any? { |box| box.count.zero? }

      check_known_values
    end

    private

    attr_reader :puzzle, :square_length, :related_boxes_finder

    def check_known_values
      (square_length**2).times do |index|
        [
          find_row_boxes_for(index),
          find_column_boxes_for(index),
          find_sub_square_boxes_for(index)
        ].each do |related_boxes|
          raise DuplicatedValuesError if duplicated_known_values?(related_boxes)
        end
      end
    end

    def find_row_boxes_for(row_number)
      related_boxes_finder.find_row_boxes_from(puzzle, row_number)
    end

    def find_column_boxes_for(column_number)
      related_boxes_finder.find_column_boxes_from(puzzle, column_number)
    end

    def find_sub_square_boxes_for(sub_square_index)
      related_boxes_finder.find_sub_square_boxes_from(puzzle, sub_square_index)
    end

    def duplicated_known_values?(related_boxes)
      all_values = related_boxes.select { |box_values| box_values.count == 1 }.flatten

      all_values.uniq != all_values
    end
  end
end
