# frozen_string_literal: true

class BranchSolver
  extend Forwardable

  FILTERS = [
    Filters::RemoveKnownValues.new,
    Filters::RemoveRestrictedValues.new
  ].freeze

  def_delegators :validator, :valid?, :solved?

  def initialize(puzzle:, square_length:, related_boxes_finder:)
    @puzzle = puzzle
    @square_length = square_length
    @related_boxes_finder = related_boxes_finder
  end

  def solve
    loop do
      starting_total_possibilities = puzzle.flatten.count

      (square_length**2).times { |index| run_filters_for(index) }

      ending_total_possibilities = puzzle.flatten.count

      break if starting_total_possibilities == ending_total_possibilities
    end
  end

  private

  attr_reader :puzzle, :square_length, :related_boxes_finder

  def validator
    @validator ||=
      Validators::PuzzleValidator.new(
        puzzle: puzzle,
        square_length: square_length,
        related_boxes_finder: related_boxes_finder
      )
  end

  def run_filters_for(index)
    %i[row column sub_square].each do |box_type|
      boxes = related_boxes_finder.find(puzzle, box_type: box_type, index: index)

      FILTERS.each { |filter| filter.call(boxes) }
    end
  end
end
