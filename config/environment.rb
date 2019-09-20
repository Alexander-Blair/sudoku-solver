# frozen_string_literal: true

require 'pathname'

APP_ROOT = Pathname.new(__dir__).parent
$LOAD_PATH.unshift File.join(APP_ROOT, 'lib') unless $LOAD_PATH.include?(File.join(APP_ROOT, 'lib'))

APP_ENV  ||= ENV.fetch('APP_ENV', 'development').to_sym
APP_HOST ||= ENV.fetch('HOST', 'localhost')
APP_NAME = 'sudoku-solver'

require 'bundler/setup'
Bundler.require(:default, APP_ENV)

require_relative 'autoloading'
