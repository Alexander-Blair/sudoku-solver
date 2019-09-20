# frozen_string_literal: true

require 'spec_helper'
require 'horizontal_line_indexes'

RSpec.describe HorizontalLineIndexes do
  describe '#find' do
    subject(:indexes) do
      described_class.new(square_length).find(row_number)
    end

    [
      [1, 0, [0]],
      [2, 0, [0, 1, 2, 3]],
      [2, 1, [4, 5, 6, 7]],
      [2, 2, [8, 9, 10, 11]],
      [2, 3, [12, 13, 14, 15]],
      [3, 0, (0..8).to_a],
      [3, 1, (9..17).to_a],
      [3, 2, (18..26).to_a],
      [3, 3, (27..35).to_a],
      [3, 4, (36..44).to_a],
      [3, 5, (45..53).to_a],
      [3, 6, (54..62).to_a],
      [3, 7, (63..71).to_a],
      [3, 8, (72..80).to_a],
      [4, 0, (0..15).to_a]
    ].each do |square_length, row_number, expected_result|
      context "when square length is #{square_length} and row number is #{row_number}" do
        let(:square_length) { square_length }
        let(:row_number) { row_number }

        it { is_expected.to eq expected_result }
      end
    end
  end
end
