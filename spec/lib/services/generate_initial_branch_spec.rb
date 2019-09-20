# frozen_string_literal: true

require 'spec_helper'
require 'services/generate_initial_branch'

RSpec.describe Services::GenerateInitialBranch do
  describe '.call' do
    subject(:initial_branch) do
      described_class.call(puzzle: puzzle, square_length: square_length)
    end

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
end
