# frozen_string_literal: true

module RackTestMixin
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.parse_file('./config.ru').first
  end
end
