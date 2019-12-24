# frozen_string_literal: true

module Filters
  class RemoveKnownValues
    def call(related_boxes)
      known_values = known_values_for(related_boxes)

      related_boxes.each do |box_values|
        next if box_values.count == 1

        known_values.each { |value| box_values.delete(value) }
      end
    end

    private

    def known_values_for(related_boxes)
      related_boxes
        .select { |box_values| box_values.count == 1 }
        .map(&:first)
    end
  end
end
