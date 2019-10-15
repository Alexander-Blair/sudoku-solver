# frozen_string_literal: true

class BranchGenerator
  def generate_initial_branch(puzzle, square_length)
    puzzle.map do |box_value|
      box_value.nil? ? (1..square_length**2).to_a : [box_value]
    end
  end

  def generate_next_branches(source_branch)
    index_of_box_to_branch_from = index_of_box_to_branch_from_for(source_branch)

    source_branch[index_of_box_to_branch_from].map do |value|
      source_branch.map(&:clone).tap do |new_branch|
        new_branch[index_of_box_to_branch_from] = [value]
      end
    end
  end

  private

  def index_of_box_to_branch_from_for(source_branch)
    box = source_branch
          .reject { |box_values| box_values.count == 1 }
          .min_by(&:count)

    source_branch.index box
  end
end
