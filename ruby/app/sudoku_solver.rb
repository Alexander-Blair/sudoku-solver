# frozen_string_literal: true

require 'sinatra'

module SudokuSolver
  class Healthcheck < Sinatra::Base
    get '/' do
      'Hello world!'
    end
  end

  class Solver < Sinatra::Base
    before do
      validate_content_type('application/json')
    end

    post '/solve' do
      content_type :json
      {
        solution: PuzzleSolver.new(
          puzzle: params.fetch('puzzle'),
          square_length: params.fetch('square_length')
        ).call
      }.to_json
    end

    private

    def validate_content_type(expected_content_type)
      pass if request.content_type == expected_content_type

      halt 400, "Content-Type #{request.content_type}; should be #{expected_content_type}"
    end
  end
end
