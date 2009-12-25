require 'rubygems'
require 'soundcloud'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
#require 'oauth'
require 'haml'

#enable :sessions

class Track
	include DataMapper::Resource
	property :id, Serial
	property :sc_id, Integer
	property :played, Integer, :default => 0
	property :favorite, Boolean
	#property :style, String
	property :quality, Integer
	property :energy, Integer
	property :created_at, DateTime
	property :updated_at, DateTime

	has n, :styles, :through => Resource

	
	def username
   @@sc_client.Track.find(self.sc_id).attributes["user"].attributes["username"]
	end

	def method_missing name, *args
		@@sc_client.Track.find(self.sc_id).attributes[name.to_s]
	end

end

class Style
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	has n, :tracks, :through => Resource
end

class Playlist
end

class Player
	#property :mode
	#def follow_producer
	#end
	#def back
	#end
	#def follow_following
	#end
	#def toggle_favorites
	#end
end

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/scc.sqlite3")
DataMapper.auto_migrate! unless File.exists? "scc.sqlite3"

@@sc_client = Soundcloud.register#('tabcwIWB7dv9KT5Sy2rQ','zFMrmC87pisbnEY3lAG7BlaghEPgqDKGl4iXNYd0')
get '/?' do
	#user = @@sc_client.User.find('in-silico')
  @tracks = Track.all
  haml :index
end

post '/:id' do
	# save previous track
	track = Track.get!(params[:track_id].to_i)
	quality = params[:quality]
	if quality
		case quality
		when "remove"
			track.favorite = false
			track.quality = nil
		else
			track.favorite = true
			track.quality = quality
		end
		track.style = params[:style] if params['style']
		track.energy = params[:energy] if params['energy']
		track.styles = []
		params[:style].each do |s,v| 
			style = Style.first(:name => s)
			style = Style.new(:name => s) unless style
			style.save
			track.styles << style
		end
		track.save
	end
	
	user = @@sc_client.User.find('in-silico')
	@next_track = user.favorites.sort_by{ rand }.first
	@track = Track.first(:sc_id => params[:id]) or @track = Track.create(:sc_id => params[:id])
	@styles = @track.styles.collect{|s| s.name}
	@played = @track.played
	@track.played += 1
	@track.save
	haml :play
end

get '/:id' do
	user = @@sc_client.User.find('in-silico')
	@next_track = user.favorites.sort_by{ rand }.first
	@track = Track.first(:sc_id => params[:id]) or @track = Track.create(:sc_id => params[:id])
	@styles = @track.styles.collect{|s| s.name}
	@played = @track.played
	@track.played += 1
	@track.save
	haml :play
end

get '/:id/add_favorite' do
	@track = Track.first(:sc_id => params[:id])
	@track.favorite = true
	@track.save
	haml :play
end

get '/:id/remove_favorite' do
	@track = Track.first(:sc_id => params[:id])
	@track.favorite = false
	@track.save
	haml :play
end


