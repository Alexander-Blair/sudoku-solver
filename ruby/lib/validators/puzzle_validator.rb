# frozen_string_literal: true

module Validators
  class PuzzleValidator
    def initialize(puzzle:, square_length:, related_boxes_finder:)
      @puzzle = puzzle
      @square_length = square_length
      @related_boxes_finder = related_boxes_finder
    end

    def valid?
      @valid ||= puzzle.none? { |box| box.count.zero? } && no_duplicated_values?
    end

    def solved?
      valid? && puzzle.all? { |box| box.count == 1 }
    end

    private

    attr_reader :puzzle, :square_length, :related_boxes_finder

    def no_duplicated_values?
      (square_length**2).times.all? do |index|
        %i[row column sub_square].all? do |box_type|
          related_boxes = related_boxes_finder.find(puzzle, box_type: box_type, index: index)

          all_values = related_boxes.select { |box_values| box_values.count == 1 }.flatten

          all_values.uniq == all_values
        end
      end
    end
  end
end
