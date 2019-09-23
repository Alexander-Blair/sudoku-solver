# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Validators::ValidatePuzzle do
  subject(:validate_puzzle) do
    described_class.call(
      puzzle: puzzle,
      square_length: square_length,
      related_boxes_finder: related_boxes_finder
    )
  end
  let(:related_boxes_finder) { RelatedBoxesFinder.new(square_length) }

  describe '.call' do
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

          it 'raises error' do
            expect { validate_puzzle }.to raise_error(described_class::DuplicatedValuesError)
          end
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

          it 'raises error' do
            expect { validate_puzzle }.to raise_error(described_class::DuplicatedValuesError)
          end
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

          it 'raises error' do
            expect { validate_puzzle }.to raise_error(described_class::DuplicatedValuesError)
          end
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

        it 'raises error' do
          expect { validate_puzzle }.to raise_error(described_class::NoPossibleValuesFoundError)
        end
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

        it 'raises error' do
          expect { validate_puzzle }.to raise_error(described_class::DuplicatedValuesError)
        end
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

        it 'raises error' do
          expect { validate_puzzle }.to raise_error(described_class::DuplicatedValuesError)
        end
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

        it 'raises error' do
          expect { validate_puzzle }.to raise_error(described_class::DuplicatedValuesError)
        end
      end
    end
  end
end
