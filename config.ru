Encoding.default_external = 'utf-8'

require 'rubygems'
require 'bundler/setup'
require 'sinatra'

require 'sinatra/reloader' if settings.environment == :development

require './transpharm'
require './lib/dict'
require './lib/medsearch'
require './lib/addwords'

run Sinatra::Application