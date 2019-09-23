# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'solving an easy puzzle' do
  let(:puzzle) do
    JSON.parse IO.binread('spec/support/fixtures/puzzle_easy_0.json')
  end
  let(:solution) do
    [
      [4], [5], [6], [7], [2], [9], [3], [8], [1],
      [3], [2], [1], [6], [8], [5], [9], [7], [4],
      [7], [8], [9], [3], [4], [1], [6], [2], [5],
      [1], [7], [5], [8], [6], [4], [2], [3], [9],
      [2], [6], [3], [1], [9], [7], [4], [5], [8],
      [8], [9], [4], [5], [3], [2], [7], [1], [6],
      [6], [3], [7], [4], [5], [8], [1], [9], [2],
      [9], [1], [8], [2], [7], [6], [5], [4], [3],
      [5], [4], [2], [9], [1], [3], [8], [6], [7]
    ]
  end

  it 'completes the puzzle' do
    expect(Solver.new(puzzle: puzzle, square_length: 3).call).to eq solution
  end
end
