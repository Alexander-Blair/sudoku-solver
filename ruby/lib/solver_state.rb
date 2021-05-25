# frozen_string_literal: true

class SolverState
  class << self
    attr_reader :solution_state

    def run(initial_state)
      @solutions_count = 0
      @solution_state = nil
      solve(initial_state)

      raise NoSolutionFoundError unless solution_state

      solution_state
    end

    def solve(state)
      if state.solved?
        @solutions_count += 1

        raise MultipleSolutionsError if @solutions_count > 1

        @solution_state = state
      end

      literal_id = state.next_literal_id || return

      new_state = state.deep_clone

      solve(state) if state.assert(literal_id)
      solve(new_state) if new_state.assert(-literal_id)
    end
  end

  attr_reader :asserted, :guesses

  def initialize(solved_puzzle_assertion_count:)
    @solved_puzzle_assertion_count = solved_puzzle_assertion_count

    @guesses = 0

    @implications = {}
    @clauses = {}
    @eliminations_until_binary = {}
    @asserted = {}

    # Mapping from literal ids to the clauses that contain it
    @literal_id_to_clause_ids = {}

    # Clauses from which to branch from when we need to make a guess
    @branch_from_clauses = []
  end

  def deep_clone
    new_instance = dup
    @implications = @implications.transform_values(&:dup)
    @asserted = @asserted.dup
    @eliminations_until_binary = @eliminations_until_binary.dup
    @branch_from_clauses = branch_from_clauses.dup
    new_instance
  end

  def solved?
    solved_puzzle_assertion_count == asserted.count
  end

  def next_literal_id
    @guesses += 1
    literal_id = nil

    branch_from_clauses.select! { |id| eliminations_until_binary[id] >= 0 }
    branch_from_clauses
      .sort_by { |id| eliminations_until_binary[id] }
      .detect do |clause_id|
        literal_id = clauses[clause_id].detect { |id| !asserted[id] && !asserted[-id] }
      end

    literal_id
  end

  def assert(id)
    return false if asserted[-id]
    return true if asserted[id]

    asserted[id] = true

    clear_literal_from_clauses_containing_its_negation(id)

    implications[id] ? implications[id].all? { |implied_id| assert(implied_id) } : true
  end

  def add_exactly_n_constraint(ids, count, branch_from: false)
    add_clause(ids, count, branch_from: branch_from)

    if count == 1
      add_binary_implications(ids)
    else
      negated_ids = ids.map(&:-@)
      add_clause(negated_ids, ids.count - count)
    end
  end

  private

  attr_reader :implications,
              :clauses,
              :literal_id_to_clause_ids,
              :branch_from_clauses,
              :solved_puzzle_assertion_count,
              :eliminations_until_binary

  def clear_literal_from_clauses_containing_its_negation(literal_id)
    literal_id_to_clause_ids[-literal_id]&.each do |clause_id|
      eliminations_until_binary[clause_id] -= 1

      if eliminations_until_binary[clause_id].zero?
        ids = clauses[clause_id].each_with_object([]) do |id, noneliminated_ids|
          noneliminated_ids << -id unless asserted[-id]
        end
        add_binary_implications(ids)
      end
    end
  end

  def add_binary_implications(ids)
    ids.combination(2).each do |a, b|
      (implications[a] ||= []) << -b
      (implications[b] ||= []) << -a
    end
  end

  def add_clause(ids, count, branch_from: false)
    clause_id = clauses.count

    branch_from_clauses << clause_id if branch_from
    clauses[clause_id] = ids
    eliminations_until_binary[clause_id] = ids.count - count - 1

    ids.each { |id| (literal_id_to_clause_ids[id] ||= []) << clause_id }
  end
end
