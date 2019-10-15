# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BranchGenerator do
  let(:generator) { described_class.new }

  describe '#generate_initial' do
    subject(:initial_branch) { generator.generate_initial(puzzle, square_length) }

    let(:puzzle) { [nil, nil, 5] }

    context 'when square length is 1' do
      let(:square_length) { 1 }
      let(:expected_result) do
        { 0 => [[1], [1], [5]] }
      end

      it { is_expected.to eq expected_result }
    end

    context 'when square length is 2' do
      let(:square_length) { 2 }
      let(:expected_result) do
        { 0 => [[1, 2, 3, 4], [1, 2, 3, 4], [5]] }
      end

      it { is_expected.to eq expected_result }
    end

    context 'when square length is 3' do
      let(:square_length) { 3 }
      let(:expected_result) do
        {
          0 => [
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [5]
          ]
        }
      end

      it { is_expected.to eq expected_result }
    end
  end

  describe '#generate_next' do
    let(:generate_next_branches) { generator.generate_next(branches, current_branch_number) }

    context 'when generating the first set of branches' do
      let(:branches) do
        { 0 => [[1, 2, 3], [3], [4, 5], [5, 6]] }
      end
      let(:current_branch_number) { 0 }

      it 'adds new branches' do
        generate_next_branches

        expect(branches).to eq(
          0 => [[1, 2, 3], [3], [4, 5], [5, 6]],
          1 => [[1, 2, 3], [3], [4], [5, 6]],
          2 => [[1, 2, 3], [3], [5], [5, 6]]
        )
      end
    end

    context 'when other branches have already been generated' do
      let(:branches) do
        {
          0 => [[1, 2, 3], [3], [4, 5], [5, 6]],
          1 => [[1, 2, 3], [3], [4], [5, 6]],
          2 => [[1, 2, 3], [3], [5], [5, 6]]
        }
      end
      let(:current_branch_number) { 1 }

      it 'adds new branches at the end' do
        generate_next_branches

        expect(branches).to eq(
          0 => [[1, 2, 3], [3], [4, 5], [5, 6]],
          1 => [[1, 2, 3], [3], [4], [5, 6]],
          2 => [[1, 2, 3], [3], [5], [5, 6]],
          3 => [[1, 2, 3], [3], [4], [5]],
          4 => [[1, 2, 3], [3], [4], [6]]
        )
      end
    end
  end
end
