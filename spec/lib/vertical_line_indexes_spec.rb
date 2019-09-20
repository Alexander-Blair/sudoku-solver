# frozen_string_literal: true

require 'spec_helper'
require 'vertical_line_indexes'

RSpec.describe VerticalLineIndexes do
  describe '#find' do
    subject(:indexes) do
      described_class.new(square_length).find(column_number)
    end

    [
      [1, 0, [0]],
      [2, 0, [0, 4, 8, 12]],
      [2, 1, [1, 5, 9, 13]],
      [2, 2, [2, 6, 10, 14]],
      [2, 3, [3, 7, 11, 15]],
      [3, 0, [0, 9, 18, 27, 36, 45, 54, 63, 72]],
      [3, 1, [1, 10, 19, 28, 37, 46, 55, 64, 73]],
      [3, 2, [2, 11, 20, 29, 38, 47, 56, 65, 74]],
      [3, 3, [3, 12, 21, 30, 39, 48, 57, 66, 75]],
      [3, 4, [4, 13, 22, 31, 40, 49, 58, 67, 76]],
      [3, 5, [5, 14, 23, 32, 41, 50, 59, 68, 77]],
      [3, 6, [6, 15, 24, 33, 42, 51, 60, 69, 78]],
      [3, 7, [7, 16, 25, 34, 43, 52, 61, 70, 79]],
      [3, 8, [8, 17, 26, 35, 44, 53, 62, 71, 80]],
      [4, 0, [0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240]]
    ].each do |square_length, column_number, expected_result|
      context "when square length is #{square_length} and column number is #{column_number}" do
        let(:square_length) { square_length }
        let(:column_number) { column_number }

        it { is_expected.to eq expected_result }
      end
    end
  end
end
