# frozen_string_literal: true

module Filters
  class RemoveRestrictedValues
    def self.call(related_boxes)
      new(related_boxes).call
    end

    def initialize(related_boxes)
      @related_boxes = related_boxes
    end

    def call
      [4, 3, 2].each do |number_of_restricted_values|
        box_combinations_with_restricted_values(number_of_restricted_values)
          .each do |boxes_with_restricted_values|
            remove_restricted_values_from_other_boxes(boxes_with_restricted_values)
          end
      end

      related_boxes
    end

    private

    attr_reader :related_boxes

    def remove_restricted_values_from_other_boxes(boxes_with_restricted_values)
      boxes_to_remove_values_from = unknown_boxes.reject do |box|
        boxes_with_restricted_values.include? box
      end

      boxes_with_restricted_values.flatten.uniq.each do |restricted_value|
        boxes_to_remove_values_from.each do |box|
          box.delete(restricted_value)
        end
      end
    end

    def box_combinations_with_restricted_values(number_of_restricted_values)
      box_combinations_to_check(number_of_restricted_values).select do |combo|
        combo.flatten.uniq.count == number_of_restricted_values
      end
    end

    def box_combinations_to_check(number_of_restricted_values)
      unknown_boxes
        .select { |box_values| box_values.count <= number_of_restricted_values }
        .combination(number_of_restricted_values)
    end

    def unknown_boxes
      related_boxes.select { |box_values| box_values.count > 1 }
    end
  end
end
