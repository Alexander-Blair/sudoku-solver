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

  HORIZONTAL_BAND_TRIADS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
  ].freeze

  VERTICAL_BAND_TRIADS = [
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8]
  ].freeze

  VALUES = (1..9).freeze

  # box index / row index / column index
  PRINT_MAP = %w[
    000 001 002 100 101 102 200 201 202
    010 011 012 110 111 112 210 211 212
    020 021 022 120 121 122 220 221 222

    300 301 302 400 401 402 500 501 502
    310 311 312 410 411 412 510 511 512
    320 321 322 420 421 422 520 521 522

    600 601 602 700 701 702 800 801 802
    610 611 612 710 711 712 810 811 812
    620 621 622 720 721 722 820 821 822
  ].freeze

  # 9 values, 9 boxes, 15 literals per box (includes the 9 puzzle squares, plus
  # 3 vertical literals, and 3 horizontal literals
  SOLVED_PUZZLE_ASSERTION_COUNT = 1215

  extend self

  def solve_multi(puzzles)
    guesses = []
    times = []
    max_guesses = 0
    num_guesses = nil
    max_guess_index = nil
    puzzles.each_with_index do |p, i|
      puts "Puzzle number: #{i}" if (i % 100).zero?

      times << Benchmark.measure { num_guesses, _solution = solve(p) }.real

      guesses << num_guesses
      if num_guesses > max_guesses
        max_guess_index = i
        max_guesses = num_guesses
      end
    end
    puts "Average number of guesses: #{guesses.sum / puzzles.count}"
    puts "Max number of guesses: #{max_guesses}; index: #{max_guess_index}"
    puts "Longest time: #{times.max}"
  end

  def solve(puzzle)
    state = puzzle_state.deep_clone

    solution_state = nil

    time_taken = (Benchmark.measure do
      convert_puzzle_to_coordinates(puzzle).each { |a| state.assert(generate_id(*a)) }

      solution_state = SolverState.run(state)
    end)
    puts "Time taken: #{time_taken}"

    Sudoku.print_progress(solution_state.asserted)
  end

  def convert_puzzle_to_coordinates(puzzle)
    puzzle.each_with_object([]).with_index do |(val, coords), i|
      next unless val

      box_index = (i / 27) * 3 + (i % 9) / 3
      row_index = i / 9 - (i / 27 * 3)
      column_index = i % 3

      coords << [box_index, row_index, column_index, val]
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

  def print_progress(asserted)
    values = []
    PRINT_MAP.each do |base_id|
      increment = 1
      found = false
      until increment == 10 || found
        if asserted[base_id.to_i * 10 + increment]
          found = true
          values << increment
        end
        increment += 1
      end
      values << nil unless found
    end

    values
  end

  private

  def setup_each_cell_has_value_constraint(state, box_index)
    # Add cell exactly one constraints, i.e. stating that each cell contains a value from 1-9
    BOX_COORDINATES.each do |row_i, col_i|
      literal_ids = VALUES.map { |value| generate_id(box_index, row_i, col_i, value) }
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
      literal_ids = VALUES.map { |value| generate_id(box_index, row_i, col_i, value) }
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
          ids = inner_boxes_coordinates.map { |row, col| generate_id(box_index, row, col, value) }
          ids << generate_negative_id(box_index, outer_box_coordinates[0], outer_box_coordinates[1], value)
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
        ids = coord_set.map { |row, col| generate_id(box_index, row, col, value) }
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
          ids = band_triad.map { |box_i| generate_id(box_i, row_i, col_i, value) }
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
          ids = band_triad.map { |box_i| generate_id(box_i, row_i, col_i, value) }
          state.add_exactly_n_constraint(ids, 1)
        end
      end
    end
  end

  def generate_id(box_index, row_index, column_index, value)
    box_index * 10**3 + row_index * 10**2 + column_index * 10 + value
  end

  def generate_negative_id(box_index, row_index, column_index, value)
    -generate_id(box_index, row_index, column_index, value)
  end
end
