Encoding.default_external = 'utf-8'

require 'rubygems'
require 'bundler/setup'
require 'sinatra'

require 'sinatra/reloader' if settings.environment == :development

require './transpharm'

run Sinatra::Application