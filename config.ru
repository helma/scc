require 'rubygems'
require 'sinatra'
require 'application.rb'
require 'rack'
require 'rack/contrib'

use Rack::Session::Pool 
run Sinatra::Application

