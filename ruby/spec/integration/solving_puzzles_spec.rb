# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'solving puzzles' do
  %w[
    puzzle_easy_0
    puzzle_medium_0
    puzzle_hard_0
    puzzle_hard_1
    puzzle_hard_2
  ].each do |fixture_name|
    context "for fixture #{fixture_name}" do
      let(:fixture) { load_fixture(fixture_name) }

      it 'completes the puzzle' do
        expect(PuzzleSolver.new(puzzle: fixture['puzzle'], square_length: 3).call)
          .to eq fixture['solution']
      end
    end
  end
end
