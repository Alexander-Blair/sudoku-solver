# frozen_string_literal: true

require 'spec_helper'
require 'index_finder'

RSpec.describe IndexFinder do
  describe '#find' do
    let(:mock_class) do
      Class.new do
        include IndexFinder
      end
    end

    let(:indexes) do
      mock_class.new(square_length).find(line_number)
    end

    [
      [1, 1],
      [1, 2],
      [2, 4],
      [2, 5],
      [3, 9],
      [3, 10],
      [4, 17],
      [4, 18]
    ].each do |square_length, line_number|
      context "when square length is #{square_length} and line index is #{line_number}" do
        let(:square_length) { square_length }
        let(:line_number) { line_number }

        it 'raises out of range index error' do
          expect { indexes }.to raise_error(IndexOutOfRangeError)
        end
      end
    end
  end
end
