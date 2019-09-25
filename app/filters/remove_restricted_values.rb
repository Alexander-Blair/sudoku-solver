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
      [3, 2].each do |number_of_restricted_values|
        next if number_of_unknown_boxes <= number_of_restricted_values

        box_combinations_with_restricted_values =
          box_combinations_with_restricted_values_for(number_of_restricted_values)

        next if box_combinations_with_restricted_values.empty?

        box_combinations_with_restricted_values.each do |boxes_with_restricted_values|
          remove_restricted_values_from_other_boxes(boxes_with_restricted_values)
        end
      end
    end

    private

    attr_reader :related_boxes

    def remove_restricted_values_from_other_boxes(boxes_with_restricted_values)
      boxes_to_remove_values_from = related_boxes.select do |box|
        box.count > 1 && !boxes_with_restricted_values.include?(box)
      end

      restricted_values = boxes_with_restricted_values.flatten.uniq

      restricted_values.each do |restricted_value|
        boxes_to_remove_values_from.each do |box|
          box.delete(restricted_value)
        end
      end
    end

    def box_combinations_with_restricted_values_for(number_of_restricted_values)
      box_combinations_to_check(number_of_restricted_values).select do |combo|
        combo.flatten.uniq.count == number_of_restricted_values
      end
    end

    def box_combinations_to_check(number_of_restricted_values)
      eligible_boxes(number_of_restricted_values).combination(number_of_restricted_values)
    end

    def eligible_boxes(number_of_restricted_values)
      related_boxes.select do |box_values|
        box_values.count > 1 && box_values.count <= number_of_restricted_values
      end
    end

    def number_of_unknown_boxes
      related_boxes.select { |box| box.count > 1 }.count
    end
  end
end
