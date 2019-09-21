# frozen_string_literal: true

module Models
  module IndexFinder
    def initialize(square_length)
      @square_length = square_length
    end

    def find(index)
      raise IndexOutOfRangeError if index > board_length - 1

      (@indexes || {})[index] ||= calculate_indexes(index)
    end

    private

    attr_reader :square_length

    def board_length
      @board_length ||= square_length**2
    end
  end
end
