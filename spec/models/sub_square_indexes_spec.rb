# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Models::SubSquareIndexes do
  describe '#find' do
    subject(:indexes) do
      described_class.new(square_length).find(sub_square_index)
    end

    [
      [1, 0, [0]],
      [2, 0, [0, 1, 4, 5]],
      [2, 1, [2, 3, 6, 7]],
      [2, 2, [8, 9, 12, 13]],
      [2, 3, [10, 11, 14, 15]],
      [3, 0, [0, 1, 2, 9, 10, 11, 18, 19, 20]],
      [3, 1, [3, 4, 5, 12, 13, 14, 21, 22, 23]],
      [3, 2, [6, 7, 8, 15, 16, 17, 24, 25, 26]],
      [3, 3, [27, 28, 29, 36, 37, 38, 45, 46, 47]],
      [3, 4, [30, 31, 32, 39, 40, 41, 48, 49, 50]],
      [3, 5, [33, 34, 35, 42, 43, 44, 51, 52, 53]],
      [3, 6, [54, 55, 56, 63, 64, 65, 72, 73, 74]],
      [3, 7, [57, 58, 59, 66, 67, 68, 75, 76, 77]],
      [3, 8, [60, 61, 62, 69, 70, 71, 78, 79, 80]],
      [4, 0, [0, 1, 2, 3, 16, 17, 18, 19, 32, 33, 34, 35, 48, 49, 50, 51]]
    ].each do |square_length, sub_square_index, expected_result|
      context "when square length is #{square_length} and line index is #{sub_square_index}" do
        let(:square_length) { square_length }
        let(:sub_square_index) { sub_square_index }

        it { is_expected.to eq expected_result }
      end
    end
  end
end
