# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Filters::RemoveRestrictedValues do
  describe '.call' do
    subject(:filter_boxes) { described_class.call(related_boxes) }

    context 'when two values are restricted to two squares' do
      let(:related_boxes) do
        [[1, 2, 3, 4], [1, 2], [1, 2]]
      end

      it 'removes restricted values from other boxes' do
        filter_boxes

        expect(related_boxes).to eq [[3, 4], [1, 2], [1, 2]]
      end
    end

    context 'when three values are restricted to three squares' do
      let(:related_boxes) do
        [[1, 2, 3], [1, 2, 3, 4], [1, 2, 3], [1, 2, 3]]
      end

      it 'removes restricted values from other boxes' do
        filter_boxes

        expect(related_boxes).to eq [[1, 2, 3], [4], [1, 2, 3], [1, 2, 3]]
      end
    end

    context 'when four values are restricted to four squares' do
      let(:related_boxes) do
        [[1, 2, 3, 4], [1, 2, 3, 4, 5, 6], [1, 3, 4], [1, 2, 3, 4], [1, 2, 4]]
      end

      it 'removes restricted values from other boxes' do
        filter_boxes

        expect(related_boxes).to eq(
          [[1, 2, 3, 4], [5, 6], [1, 3, 4], [1, 2, 3, 4], [1, 2, 4]]
        )
      end
    end
  end
end
