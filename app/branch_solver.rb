# frozen_string_literal: true

class BranchSolver
  extend Forwardable

  FILTERS = [Filters::RemoveKnownValues, Filters::RemoveRestrictedValues].freeze

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
    [
      related_boxes_finder.find(puzzle, box_type: :row, index: index),
      related_boxes_finder.find(puzzle, box_type: :column, index: index),
      related_boxes_finder.find(puzzle, box_type: :sub_square, index: index)
    ].each do |related_boxes|
      FILTERS.each { |filter| filter.call(related_boxes) }
    end
  end
end
