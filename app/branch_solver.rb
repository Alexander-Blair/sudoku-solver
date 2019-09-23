# frozen_string_literal: true

class BranchSolver
  FILTERS = [Filters::RemoveKnownValues, Filters::RemoveRestrictedValues].freeze

  IncompletePuzzleError = Class.new(StandardError)

  def self.call(puzzle:, square_length:, related_boxes_finder:)
    new(puzzle, square_length, related_boxes_finder).call
  end

  def initialize(puzzle, square_length, related_boxes_finder)
    @puzzle = puzzle
    @square_length = square_length
    @related_boxes_finder = related_boxes_finder
  end

  def call
    loop do
      starting_total_possibilities = puzzle.flatten.count

      (square_length**2).times { |index| run_filters_for(index) }

      ending_total_possibilities = puzzle.flatten.count

      validate_puzzle
      break if solved?(ending_total_possibilities)
      raise IncompletePuzzleError if starting_total_possibilities == ending_total_possibilities
    end
  end

  private

  attr_reader :puzzle, :square_length, :related_boxes_finder

  def validate_puzzle
    Validators::ValidatePuzzle.call(
      puzzle: puzzle,
      square_length: square_length,
      related_boxes_finder: related_boxes_finder
    )
  end

  def solved?(ending_total_possibilities)
    ending_total_possibilities == puzzle.count
  end

  def run_filters_for(index)
    [
      related_boxes_finder.find_row_boxes_from(puzzle, index),
      related_boxes_finder.find_column_boxes_from(puzzle, index),
      related_boxes_finder.find_sub_square_boxes_from(puzzle, index)
    ].each do |related_boxes|
      FILTERS.each { |filter| filter.call(related_boxes) }
    end
  end
end
