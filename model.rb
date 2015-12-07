require 'dm-core'
require 'dm-timestamps'

class Track
	include DataMapper::Resource
	property :id, Serial
	property :sc_id, Integer
	property :played, Integer, :default => 0
	property :favorite, Boolean, :default => false
	property :quality, Integer
	property :energy, Integer
	property :created_at, DateTime
	property :updated_at, DateTime

	has n, :styles, :through => Resource

	def played?
		self.played > 0
	end

	def self.expected_quality(sc_track)
		sc_track.comments.size.to_f/sc_track.playback_count
	end

end

class Style
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	has n, :tracks, :through => Resource
end

class Artist

	def self.followings(username)
		current_artist = @@client.User.find(username)
		xml = RestClient.get("http://api.soundcloud.com/users/#{current_artist.id}/followings").to_s
		followings = xml.each_line.collect{|l| l.gsub(/^\s+<permalink>(.*)<\/permalink>\s+$/,'\1') if l.match(/permalink/)}.compact
	end

	def self.expected_quality(username)
		begin
			tracks = @@client.User.find(username).tracks.collect{|t| t unless Track.first(:sc_id => t.id)}.compact
			puts tracks.size
			ratings = tracks.collect{|t| Track.expected_quality(t)}
			puts ratings.sort.reverse
			ratings.sort.reverse.first
		rescue
			0.0
		end
	end

end


DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/scc.sqlite3")
#DataMapper.auto_upgrade!
