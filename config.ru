require 'rubygems'
require 'sinatra'
require 'application.rb'
require 'rack'
require 'rack/contrib'

=begin
['public','log','tmp'].each do |dir|
	FileUtils.mkdir_p dir unless File.exists?(dir)
end
=end

log = File.new("log/#{ENV["RACK_ENV"]}.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)
 
=begin
if ENV['RACK_ENV'] == 'production'
	use Rack::MailExceptions do |mail|
		mail.to 'helma@in-silico.ch'
		mail.subject '[ERROR] %s'
	end 
elsif ENV['RACK_ENV'] == 'development'
  use Rack::Reloader 
  use Rack::ShowExceptions
end
=begin

run Sinatra::Application

