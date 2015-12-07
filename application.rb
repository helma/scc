require 'rubygems'
require 'soundcloud'
#require 'sinatra'
require 'oauth'
#require 'haml'
#require 'sass'
#require 'rest_client'
#require 'sinatra/url_for'
#gem 'sinatra-static-assets'
#require 'sinatra/static_assets'
#require 'rgl/adjacency'
#require 'rgl/dot'
#require 'model'
#require 'authorize'

# TODO page gets reloaded too often

@@sc = Soundcloud.register :consumer_key        => 'tabcwIWB7dv9KT5Sy2rQ'

#get '/' do
#access_token = YAML.load_file("access_token.yaml")
  #@sc = Soundcloud.register({:access_token => access_token})
  @me = @@sc.User.find("Alfadeo")
  #@me = @@sc.User.find("in-silico")
  #dg=RGL::DirectedAdjacencyGraph.new
  dot = "graph G {\nnode[shape=point]\n"

  @me.fans.each do |fan|
    dot << "\"#{@me.username}\" -- \"#{fan.username}\";\n"
    #dg.add_edge(@me.username,fan.username)
    fan.fans.each do |f|
      dot << "\"#{fan.username}\" -- \"#{f.username}\";\n"
      #dg.add_edge(fan.username,f.username)
    end
  end
  dot << "}\n"
  File.open("test.dot","w+"){|f| f.puts dot}
  #dg.write_to_graphic_file('svg')
  `neato -Tsvg test.dot > test.svg`
  #@me.favorites.join("\n")
#end
=begin

helpers do
	def player(sc_track,autoplay=true)
		@player_value = "http://player.soundcloud.com/player.swf?url=#{URI.encode sc_track.permalink_url}&amp;show_comments=false&amp;player_type=tiny&amp;auto_play=#{autoplay}"
  	haml :player, :layout => false 
	end
end

get '/favorites/?' do
	@tracks = Track.all(:favorite => true)
	haml :index
end

get '/play/:username' do
	puts params.inspect
	if params[:favorite]
		puts "FAVORITE" 
		track = Track.get(params[:track_id].to_i)
		track.favorite = true
		track.save
	end
	@username = params[:username]
	puts @username
	tracks = @@client.User.find(URI.encode params[:username]).tracks.collect{|t| t unless Track.first(:sc_id => t.id)}.compact
	if tracks.empty?
		redirect "/play/#{@username}i/next"
	else
		tracks.sort!{|a,b| Track.expected_quality(b) <=> Track.expected_quality(a)}
		@sc_track = tracks.first
		@track = Track.new(:sc_id => @sc_track.id)
		@track.played += 1
		@track.save
		haml :play
	end
end

get '/play/:username/next' do
	followings = Artist.followings(params[:username]).sort_by{rand}[0..2]
	followings.sort!{|a,b| Artist.expected_quality(b) <=> Artist.expected_quality(a)}
	redirect "/play/#{URI.encode followings.first}"
end

get '/style.css' do
	headers 'Content-Type' => 'text/css; charset=utf-8'
	sass :style
end
=end
