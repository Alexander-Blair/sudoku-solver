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

      with_error_handling do
        attempt_current_branch

        return
      end
    end
  end

  def attempt_current_branch
    BranchSolver.call(
      puzzle: current_branch,
      square_length: square_length,
      related_boxes_finder: related_boxes_finder
    )
  end

  def with_error_handling
    yield
  rescue BranchSolver::IncompletePuzzleError
    generate_next_branches
    self.branch_number = branch_number + 1
  rescue Validators::ValidatePuzzle::DuplicatedValuesError,
         Validators::ValidatePuzzle::NoPossibleValuesFoundError
    self.branch_number = branch_number + 1
  end

  def generate_next_branches
    Services::GenerateNextBranches.call(branches: branches, current_branch_number: branch_number)
  end

  def current_branch
    branches[branch_number]
  end

  def branches
    @branches ||=
      Services::GenerateInitialBranch.call(puzzle: puzzle, square_length: square_length)
  end

  def related_boxes_finder
    @related_boxes_finder ||= RelatedBoxesFinder.new(square_length)
  end
end
