# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BranchGenerator do
  let(:generator) { described_class.new }

  describe '#generate_initial_branch' do
    subject(:initial_branch) { generator.generate_initial_branch(puzzle, square_length) }

    let(:puzzle) { [nil, nil, 5] }

    context 'when square length is 1' do
      let(:square_length) { 1 }
      let(:expected_result) do
        [[1], [1], [5]]
      end

      it { is_expected.to eq expected_result }
    end

    context 'when square length is 2' do
      let(:square_length) { 2 }
      let(:expected_result) do
        [[1, 2, 3, 4], [1, 2, 3, 4], [5]]
      end

      it { is_expected.to eq expected_result }
    end

    context 'when square length is 3' do
      let(:square_length) { 3 }
      let(:expected_result) do
        [
          [1, 2, 3, 4, 5, 6, 7, 8, 9],
          [1, 2, 3, 4, 5, 6, 7, 8, 9],
          [5]
        ]
      end

      it { is_expected.to eq expected_result }
    end
  end

  describe '#generate_next_branches' do
    subject(:generate_next_branches) { generator.generate_next_branches(source_branch) }

    let(:source_branch) { [[1, 2, 3], [3], [4, 5], [5, 6]] }
    let(:expected_result) do
      [
        [[1, 2, 3], [3], [4], [5, 6]],
        [[1, 2, 3], [3], [5], [5, 6]]
      ]
    end

    it { is_expected.to eq expected_result }
  end
end
