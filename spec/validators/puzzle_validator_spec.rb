# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Validators::PuzzleValidator do
  subject(:validator) do
    described_class.new(
      puzzle: puzzle,
      square_length: square_length,
      related_boxes_finder: related_boxes_finder
    )
  end
  let(:related_boxes_finder) { RelatedBoxesFinder.new(square_length) }

  context 'for a square length of 2' do
    let(:square_length) { 2 }

    [
      [
        [1],          [1, 2, 3, 4], [1],          [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]
      ],
      [
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [3],          [3],          [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]
      ]
    ].each do |example|
      context 'when values are duplicated in a row' do
        let(:puzzle) { example }

        it { is_expected.not_to be_valid }
        it { is_expected.not_to be_solved }
      end
    end

    [
      [
        [1, 2, 3, 4], [1],          [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1],          [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]
      ],
      [
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [2],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [2]
      ]
    ].each do |example|
      context 'when values are duplicated in a column' do
        let(:puzzle) { example }

        it { is_expected.not_to be_valid }
        it { is_expected.not_to be_solved }
      end
    end

    [
      [
        [1, 2, 3, 4], [1],          [1, 2, 3, 4], [1, 2, 3, 4],
        [1],          [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]
      ],
      [
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1],          [1, 2, 3, 4],
        [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1]
      ]
    ].each do |example|
      context 'when values are duplicated in a sub square' do
        let(:puzzle) { example }

        it { is_expected.not_to be_valid }
        it { is_expected.not_to be_solved }
      end
    end

    context 'when a box has no possible values' do
      let(:puzzle) do
        [
          [1, 2, 3, 4], [],           [1, 2, 3, 4], [1, 2, 3, 4],
          [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]
        ]
      end

      it { is_expected.not_to be_valid }
      it { is_expected.not_to be_solved }
    end

    context 'when solution is valid and is also solved' do
      let(:puzzle) do
        [
          [1], [2], [3], [4],
          [3], [4], [1], [2],
          [2], [1], [4], [3],
          [4], [3], [2], [1]
        ]
      end

      it { is_expected.to be_valid }
      it { is_expected.to be_solved }
    end

    context 'when solution is valid but not yet solved' do
      let(:puzzle) do
        [
          [1, 2], [2], [3], [4],
          [3],    [4], [1], [2],
          [1, 2], [1], [4], [3],
          [4],    [3], [2], [1]
        ]
      end

      it { is_expected.to be_valid }
      it { is_expected.not_to be_solved }
    end
  end

  context 'for square length 3' do
    let(:square_length) { 3 }

    context 'when row has duplicate known values' do
      let(:puzzle) do
        # rubocop:disable Metrics/LineLength
        [
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          [2],         (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, [2],         (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a
        ]
        # rubocop:enable Metrics/LineLength
      end

      it { is_expected.not_to be_valid }
      it { is_expected.not_to be_solved }
    end

    context 'when column has duplicate known values' do
      let(:puzzle) do
        # rubocop:disable Metrics/LineLength
        [
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, [2],         (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, [2],         (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a
        ]
        # rubocop:enable Metrics/LineLength
      end

      it { is_expected.not_to be_valid }
      it { is_expected.not_to be_solved }
    end

    context 'when sub square has duplicate known values' do
      let(:puzzle) do
        # rubocop:disable Metrics/LineLength
        [
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, [2],
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, [2],         (1..9).to_a, (1..9).to_a,
          (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a, (1..9).to_a
        ]
        # rubocop:enable Metrics/LineLength
      end

      it { is_expected.not_to be_valid }
      it { is_expected.not_to be_solved }
    end
  end
end
