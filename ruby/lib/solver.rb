# frozen_string_literal: true

require 'benchmark'

class Solver
  CannotSolvePuzzleError = Class.new(StandardError)

  def initialize(puzzle:, square_length: 3)
    @puzzle = puzzle
    @square_length = square_length
    @branch_number = 0
  end

  def call
    puts(Benchmark.measure { attempt_puzzle })

    current_branch
  end

  private

  attr_reader :puzzle, :square_length
  attr_accessor :branch_number

  def attempt_puzzle
    loop do
      raise CannotSolvePuzzleError if current_branch.nil?

      solver = create_solver
      solver.solve

      break if solver.solved?

      generate_next_branches if solver.valid?

      self.branch_number = branch_number + 1
    end
  end

  def create_solver
    BranchSolver.new(
      puzzle: current_branch,
      square_length: square_length,
      related_boxes_finder: related_boxes_finder
    )
  end

  def generate_next_branches
    generator.generate_next(branches, branch_number)
  end

  def current_branch
    branches[branch_number]
  end

  def branches
    @branches ||= generator.generate_initial(puzzle, square_length)
  end

  def generator
    @generator ||= BranchGenerator.new
  end

  def related_boxes_finder
    @related_boxes_finder ||= RelatedBoxesFinder.new(square_length)
  end
end
