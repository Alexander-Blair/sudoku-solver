# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RelatedBoxesFinder do
  subject(:finder) do
    described_class.new(square_length)
  end

  describe '#find' do
    context 'when square length is 2' do
      let(:current_branch) do
        [
          [0, 0], [1, 0], [2, 0], [3, 0],
          [0, 1], [1, 1], [2, 1], [3, 1],
          [0, 2], [1, 2], [2, 2], [3, 2],
          [0, 3], [1, 3], [2, 3], [3, 3]
        ]
      end
      let(:square_length) { 2 }

      context 'for rows' do
        it 'finds the correct boxes' do
          expect(finder.find(current_branch, box_type: :row, index: 0)).to eq(
            [[0, 0], [1, 0], [2, 0], [3, 0]]
          )
          expect(finder.find(current_branch, box_type: :row, index: 2)).to eq(
            [[0, 2], [1, 2], [2, 2], [3, 2]]
          )
        end
      end

      context 'for columns' do
        it 'finds the correct boxes' do
          expect(finder.find(current_branch, box_type: :column, index: 0)).to eq(
            [[0, 0], [0, 1], [0, 2], [0, 3]]
          )
          expect(finder.find(current_branch, box_type: :column, index: 2)).to eq(
            [[2, 0], [2, 1], [2, 2], [2, 3]]
          )
        end
      end

      context 'for sub squares' do
        it 'finds the correct boxes' do
          expect(finder.find(current_branch, box_type: :sub_square, index: 0)).to eq(
            [[0, 0], [1, 0], [0, 1], [1, 1]]
          )
          expect(finder.find(current_branch, box_type: :sub_square, index: 2)).to eq(
            [[0, 2], [1, 2], [0, 3], [1, 3]]
          )
        end
      end
    end

    context 'when square length is 3' do
      let(:current_branch) do
        [
          [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [8, 0],
          [0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1],
          [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [8, 2],
          [0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3],
          [0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4], [8, 4],
          [0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5],
          [0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6],
          [0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7], [8, 7],
          [0, 8], [1, 8], [2, 8], [3, 8], [4, 8], [5, 8], [6, 8], [7, 8], [8, 8]
        ]
      end
      let(:square_length) { 3 }

      context 'for rows' do
        it 'finds the correct boxes' do
          expect(finder.find(current_branch, box_type: :row, index: 3)).to eq(
            [[0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3]]
          )
        end
      end

      context 'for columns' do
        it 'finds the correct boxes' do
          expect(finder.find(current_branch, box_type: :column, index: 4)).to eq(
            [[4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7], [4, 8]]
          )
        end
      end

      context 'for sub squares' do
        it 'finds the correct boxes' do
          expect(finder.find(current_branch, box_type: :sub_square, index: 4)).to eq(
            [[3, 3], [4, 3], [5, 3], [3, 4], [4, 4], [5, 4], [3, 5], [4, 5], [5, 5]]
          )
        end
      end
    end
  end
end
