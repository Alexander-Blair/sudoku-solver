# frozen_string_literal: true

class BranchGenerator
  def generate_initial(puzzle, square_length)
    {
      0 => puzzle.map do |box_value|
        box_value.nil? ? (1..square_length**2).to_a : [box_value]
      end
    }
  end

  def generate_next(branches, current_branch_number)
    source_branch = branches[current_branch_number]
    index_of_box_to_branch_from = index_of_box_to_branch_from_for(source_branch)

    source_branch[index_of_box_to_branch_from].each do |value|
      branches[branches.length] = source_branch.map(&:clone).tap do |new_branch|
        new_branch[index_of_box_to_branch_from] = [value]
      end
    end
  end

  private

  def index_of_box_to_branch_from_for(source_branch)
    box = source_branch
          .reject { |box_values| box_values.count == 1 }
          .min { |first_box, next_box| first_box.count <=> next_box.count }

    source_branch.index box
  end
end
