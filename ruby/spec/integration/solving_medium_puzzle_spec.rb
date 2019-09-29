# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'solving a medium puzzle' do
  let(:puzzle) { load_fixture('puzzle_medium_0') }
  let(:solution) do
    [
      [7], [5], [8], [6], [3], [2], [9], [1], [4],
      [6], [4], [1], [5], [7], [9], [2], [3], [8],
      [2], [9], [3], [4], [1], [8], [7], [6], [5],
      [5], [3], [7], [8], [6], [1], [4], [9], [2],
      [9], [8], [4], [3], [2], [5], [1], [7], [6],
      [1], [6], [2], [7], [9], [4], [5], [8], [3],
      [3], [1], [5], [2], [8], [7], [6], [4], [9],
      [4], [7], [6], [9], [5], [3], [8], [2], [1],
      [8], [2], [9], [1], [4], [6], [3], [5], [7]
    ]
  end

  it 'completes the puzzle' do
    expect(Solver.new(puzzle: puzzle, square_length: 3).call).to eq solution
  end
end
