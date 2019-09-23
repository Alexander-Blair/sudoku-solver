# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'solving hard puzzles' do
  context 'first puzzle' do
    let(:puzzle) do
      JSON.parse IO.binread('spec/support/fixtures/puzzle_hard_0.json')
    end
    let(:solution) do
      [
        [6], [5], [1], [7], [8], [2], [9], [3], [4],
        [7], [3], [8], [4], [1], [9], [5], [2], [6],
        [9], [4], [2], [5], [6], [3], [8], [7], [1],
        [5], [7], [6], [8], [2], [1], [4], [9], [3],
        [1], [2], [3], [9], [4], [7], [6], [5], [8],
        [4], [8], [9], [6], [3], [5], [2], [1], [7],
        [3], [1], [4], [2], [9], [6], [7], [8], [5],
        [8], [9], [5], [1], [7], [4], [3], [6], [2],
        [2], [6], [7], [3], [5], [8], [1], [4], [9]
      ]
    end

    it 'completes the puzzle' do
      expect(Solver.new(puzzle: puzzle, square_length: 3).call).to eq solution
    end
  end

  context 'second puzzle' do
    let(:puzzle) do
      JSON.parse IO.binread('spec/support/fixtures/puzzle_hard_1.json')
    end
    let(:solution) do
      [
        [8], [1], [2], [7], [5], [3], [6], [4], [9],
        [9], [4], [3], [6], [8], [2], [1], [7], [5],
        [6], [7], [5], [4], [9], [1], [2], [8], [3],
        [1], [5], [4], [2], [3], [7], [8], [9], [6],
        [3], [6], [9], [8], [4], [5], [7], [2], [1],
        [2], [8], [7], [1], [6], [9], [5], [3], [4],
        [5], [2], [1], [9], [7], [4], [3], [6], [8],
        [4], [3], [8], [5], [2], [6], [9], [1], [7],
        [7], [9], [6], [3], [1], [8], [4], [5], [2]
      ]
    end

    it 'completes the puzzle' do
      expect(Solver.new(puzzle: puzzle, square_length: 3).call).to eq solution
    end
  end

  context 'third puzzle' do
    let(:puzzle) do
      JSON.parse IO.binread('spec/support/fixtures/puzzle_hard_2.json')
    end
    let(:solution) do
      [
        [6], [2], [5], [1], [7], [8], [9], [4], [3],
        [9], [4], [8], [3], [2], [6], [1], [5], [7],
        [3], [7], [1], [9], [4], [5], [8], [6], [2],
        [2], [5], [7], [6], [1], [9], [3], [8], [4],
        [4], [6], [3], [5], [8], [7], [2], [9], [1],
        [1], [8], [9], [4], [3], [2], [5], [7], [6],
        [7], [9], [2], [8], [6], [3], [4], [1], [5],
        [5], [1], [6], [2], [9], [4], [7], [3], [8],
        [8], [3], [4], [7], [5], [1], [6], [2], [9]
      ]
    end

    it 'completes the puzzle' do
      expect(Solver.new(puzzle: puzzle, square_length: 3).call).to eq solution
    end
  end
end
