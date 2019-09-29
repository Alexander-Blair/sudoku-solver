# frozen_string_literal: true

module Services
  class GenerateNextBranches
    def self.call(branches:, current_branch_number:)
      new(branches, current_branch_number).call
    end

    def initialize(branches, current_branch_number)
      @branches = branches
      @current_branch_number = current_branch_number
    end

    def call
      source_branch[index_of_box_to_branch_from].each do |value|
        new_branch = copy_source_branch
        new_branch[index_of_box_to_branch_from] = [value]
        branches[branches.length] = new_branch
      end
    end

    private

    attr_reader :branches, :current_branch_number

    def copy_source_branch
      source_branch.map(&:clone)
    end

    def source_branch
      branches[current_branch_number]
    end

    def index_of_box_to_branch_from
      @index_of_box_to_branch_from ||=
        begin
          box = source_branch
                .reject { |box_values| box_values.count == 1 }
                .min { |first_box, next_box| first_box.count <=> next_box.count }

          source_branch.index box
        end
    end
  end
end
