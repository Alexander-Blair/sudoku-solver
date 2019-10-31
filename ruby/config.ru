# frozen_string_literal: true

require_relative 'config/environment'

use Rack::PostBodyContentTypeParser

run Rack::URLMap.new(
  '/healthcheck' => SudokuSolver::Healthcheck,
  '/' => SudokuSolver::Solver
)
