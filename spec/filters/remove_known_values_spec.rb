# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Filters::RemoveKnownValues do
  describe '.call' do
    let(:related_boxes) do
      [[1], [1, 2, 3, 4], [4], [1, 2, 3, 4]]
    end
    let(:expected_result) { [[1], [2, 3], [4], [2, 3]] }

    it 'removes known values from other boxes' do
      described_class.call(related_boxes)

      expect(related_boxes).to eq expected_result
    end
  end
end
