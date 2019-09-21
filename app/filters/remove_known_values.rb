# frozen_string_literal: true

module Filters
  class RemoveKnownValues
    def self.call(related_boxes)
      new(related_boxes).call
    end

    def initialize(related_boxes)
      @related_boxes = related_boxes
    end

    def call
      related_boxes.each do |box_values|
        next if box_values.count == 1

        known_values.each { |value| box_values.delete(value) }
      end
    end

    private

    attr_reader :related_boxes

    def known_values
      related_boxes
        .select { |box_values| box_values.count == 1 }
        .map(&:first)
    end
  end
end
