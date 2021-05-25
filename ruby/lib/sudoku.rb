# frozen_string_literal: true

require_relative 'solver_state'
require 'benchmark'

module Sudoku
  BOX_COORDINATES = [
    [0, 0], [0, 1], [0, 2],
    [1, 0], [1, 1], [1, 2],
    [2, 0], [2, 1], [2, 2]
  ].freeze

  HORIZONTAL_TRIAD_COORDINATES = {
    [0, 3] => [[0, 0], [0, 1], [0, 2]],
    [1, 3] => [[1, 0], [1, 1], [1, 2]],
    [2, 3] => [[2, 0], [2, 1], [2, 2]]
  }.freeze

  VERTICAL_TRIAD_COORDINATES = {
    [3, 0] => [[0, 0], [1, 0], [2, 0]],
    [3, 1] => [[0, 1], [1, 1], [2, 1]],
    [3, 2] => [[0, 2], [1, 2], [2, 2]]
  }.freeze

  HORIZONTAL_BAND_TRIADS = [[0, 1, 2], [3, 4, 5], [6, 7, 8]].freeze

  VERTICAL_BAND_TRIADS = [[0, 3, 6], [1, 4, 7], [2, 5, 8]].freeze

  VALUES = (1..9).freeze

  ID_GENERATOR = lambda do |box_index, row_index, column_index, value|
    box_index * 10**3 + row_index * 10**2 + column_index * 10 + value
  end

  # Provides a mapping from index in the puzzle (i.e. 0 - 80) to the id of the
  # set of literals for that cell. Each id points to 1 before the literal containing
  # the value of 1. So, if you wanted to check whether cell at index 10 contained a
  # 5, you could check key 10 in this hash, and then add 5 to the id, which would then
  # point at the literal for value 5.
  SOLUTION_CONVERSION_MAP = 81.times.map do |i|
    box_index = (i / 27) * 3 + (i % 9) / 3
    row_index = i / 9 - (i / 27 * 3)
    column_index = i % 3
    ID_GENERATOR.call(box_index, row_index, column_index, 0)
  end

  # 9 values, 9 boxes, 15 literals per box (includes the 9 puzzle squares, plus
  # 3 vertical literals, and 3 horizontal literals
  SOLVED_PUZZLE_ASSERTION_COUNT = 9 * 15 * 9

  extend self

  def solve(puzzle)
    state = puzzle_state.deep_clone

    solution_state = nil

    time_taken = (Benchmark.measure do
      convert_puzzle_to_ids(puzzle).each { |id| state.assert(id) }

      solution_state = SolverState.run(state)
    end)
    puts "Time taken: #{time_taken}"

    convert_asserted_to_puzzle(solution_state.asserted)
  end

  def convert_puzzle_to_ids(puzzle)
    puzzle.each_with_object([]).with_index do |(val, ids), i|
      ids << SOLUTION_CONVERSION_MAP[i] + val if val
    end
  end

  def convert_asserted_to_puzzle(asserted)
    SOLUTION_CONVERSION_MAP.map do |zero_value_id|
      VALUES.detect { |value| asserted[zero_value_id + value] }
    end
  end

  def puzzle_state
    @puzzle_state ||= SolverState.new(solved_puzzle_assertion_count: SOLVED_PUZZLE_ASSERTION_COUNT).tap do |state|
      9.times.each do |box_i|
        setup_each_cell_has_value_constraint(state, box_i)
        setup_vertical_and_horizontal_triad_constraints(state, box_i)
        setup_horizontal_and_vertical_triad_literals(state, box_i)
        setup_each_triad_literal_has_value_constraint(state, box_i)
      end

      setup_horizontal_cross_band_triad_constraints(state)
      setup_vertical_cross_band_triad_constraints(state)
    end
  end

  private

  def setup_each_cell_has_value_constraint(state, box_index)
    # Add cell exactly one constraints, i.e. stating that each cell contains a value from 1-9
    BOX_COORDINATES.each do |row_i, col_i|
      literal_ids = VALUES.map { |value| ID_GENERATOR.call(box_index, row_i, col_i, value) }
      # Setting `branch_from` to true means that, when branching to make the next guess, we
      # will choose a value for a cell from 1-9, and attempt to satisfy the puzzle with it
      state.add_exactly_n_constraint(literal_ids, 1, branch_from: true)
    end
  end

  def setup_vertical_and_horizontal_triad_constraints(state, box_index)
    # Add constraints to say that each triad of squares contains exactly three values.
    #
    # In the below diagram, the h0 constraint says that the triad x0 x1 x2 should contain
    # exactly three values (and equivalent for h1 and h2)
    #
    # The v0 constraint says that the triad x0 x3 x6 should contain exactly three values
    # (and equivalent for v1 and v2)
    #  __ __ __ __
    # |x0|x1|x2|h0|
    # |--|--|--|--|
    # |x3|x4|x5|h1|
    # |--|--|--|--|
    # |x6|x7|x8|h2|
    # |--|--|--|--|
    # |v0|v1|v2|
    #
    (HORIZONTAL_TRIAD_COORDINATES.keys + VERTICAL_TRIAD_COORDINATES.keys).each do |row_i, col_i|
      literal_ids = VALUES.map { |value| ID_GENERATOR.call(box_index, row_i, col_i, value) }
      state.add_exactly_n_constraint(literal_ids, 3)
    end
  end

  def setup_horizontal_and_vertical_triad_literals(state, box_index)
    # Add constraints to say that each triad of squares contains exactly three values.
    #
    # In the below diagram, the horizontal constraint across x0 x1 x2 h0 specify that,
    # for each value, one of the following is true:
    # - x0 contains the value
    # - x1 contains the value
    # - x2 contains the value
    # - h0 (representing the entire triad) DOES NOT contain the value
    #
    # The vertical constraints across x0, x3, x6 and v0 enforces the equivalent rule
    # (as well as the rest of the rows and columns).
    #  __ __ __ __
    # |x0|x1|x2|h0|
    # |--|--|--|--|
    # |x3|x4|x5|h1|
    # |--|--|--|--|
    # |x6|x7|x8|h2|
    # |--|--|--|--|
    # |v0|v1|v2|
    #
    [HORIZONTAL_TRIAD_COORDINATES, VERTICAL_TRIAD_COORDINATES].each do |coords|
      coords.each do |outer_box_coordinates, inner_boxes_coordinates|
        VALUES.each do |value|
          ids = inner_boxes_coordinates.map { |row, col| ID_GENERATOR.call(box_index, row, col, value) }
          ids << -ID_GENERATOR.call(box_index, outer_box_coordinates[0], outer_box_coordinates[1], value)
          state.add_exactly_n_constraint(ids, 1)
        end
      end
    end
  end

  def setup_each_triad_literal_has_value_constraint(state, box_index)
    # Add triad literal exactly one constraints, i.e. stating that each single triad literal
    # contains a value from 1-9
    [VERTICAL_TRIAD_COORDINATES.keys, HORIZONTAL_TRIAD_COORDINATES.keys].each do |coord_set|
      VALUES.each do |value|
        ids = coord_set.map { |row, col| ID_GENERATOR.call(box_index, row, col, value) }
        state.add_exactly_n_constraint(ids, 1)
      end
    end
  end

  def setup_horizontal_cross_band_triad_constraints(state)
    #  __ __ __ __    __ __ __ __    __ __ __ ___
    # |x0|x1|x2|h00| |x0|x1|x2|h10| |x0|x1|x2|h20|
    # |--|--|--|---| |--|--|--|---| |--|--|--|---|
    # |  |  |  |   | |  |  |  |   | |  |  |  |   |
    # |--|--|--|---| |--|--|--|---| |--|--|--|---|
    # |  |  |  |   | |  |  |  |   | |  |  |  |   |
    # |--|--|--|---| |--|--|--|---| |--|--|--|---|
    # |  |  |  |     |  |  |  |     |  |  |  |
    #
    # These constraints enforce that cross band horizontal triads do not contain the
    # same value. For example, the triad literals h00, h10 and h20 form a constraint
    # indicating that a given value cannot occur in more than one of them
    HORIZONTAL_BAND_TRIADS.each do |band_triad|
      HORIZONTAL_TRIAD_COORDINATES.each_key do |row_i, col_i|
        VALUES.each do |value|
          ids = band_triad.map { |box_i| ID_GENERATOR.call(box_i, row_i, col_i, value) }
          state.add_exactly_n_constraint(ids, 1)
        end
      end
    end
  end

  def setup_vertical_cross_band_triad_constraints(state)
    # Represents the same logical constraints as #setup_horizontal_cross_band_triad_constraints,
    # however in the vertical orientation
    VERTICAL_BAND_TRIADS.each do |band_triad|
      VERTICAL_TRIAD_COORDINATES.each_key do |row_i, col_i|
        VALUES.each do |value|
          ids = band_triad.map { |box_i| ID_GENERATOR.call(box_i, row_i, col_i, value) }
          state.add_exactly_n_constraint(ids, 1)
        end
      end
    end
  end
end
