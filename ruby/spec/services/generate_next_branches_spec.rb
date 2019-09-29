# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::GenerateNextBranches do
  describe '.call' do
    subject(:generate_next_branches) do
      described_class.call(branches: branches, current_branch_number: current_branch_number)
    end

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
