# frozen_string_literal: true

module Services
  class GenerateInitialBranch
    def self.call(puzzle:, square_length:)
      new(puzzle, square_length).call
    end

    def initialize(puzzle, square_length)
      @puzzle = puzzle
      @square_length = square_length
    end

    def call
      {
        0 => puzzle.map { |box_value| all_possible_values_for(box_value) }
      }
    end

    private

    attr_reader :puzzle, :square_length

    def all_possible_values_for(box_value)
      box_value.nil? ? (1..square_length**2).to_a : [box_value]
    end
  end
end
