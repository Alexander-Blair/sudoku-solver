# frozen_string_literal: true

module FixtureHelper
  def load_fixture(fixture_name)
    JSON.parse IO.binread("#{PROJECT_ROOT}/support/fixtures/#{fixture_name}.json")
  end
end
