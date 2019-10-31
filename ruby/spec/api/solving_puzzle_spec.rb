# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'submitting a puzzle to the web endpoint /solve', type: :api do
  let(:solve_puzzle) do
    post '/solve', body.to_json, headers
  end
  let(:fixture) { load_fixture('puzzle_hard_0') }
  let(:body) do
    {
      puzzle: fixture['puzzle'],
      square_length: 3
    }
  end
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json' }
  end

  it 'returns success' do
    solve_puzzle

    expect(last_response.status).to eq 200
  end

  it 'returns the solved puzzle' do
    solve_puzzle

    expect(JSON.parse(last_response.body)).to eq(
      'solution' => fixture['solution']
    )
  end
end
