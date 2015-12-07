#!/usr/bin/env ruby
require 'fileutils'
include FileUtils
require 'taglib'
require File.join(File.dirname(__FILE__),"login.rb")
sc_dir = "./soundcloud"
@client.get("/me/favorites").each do |track|
  d = track.duration/60000.0 #min
  if d > 1.5 and d < 10
    dir = File.join sc_dir, track.user.permalink
    mkdir_p dir
    if track.downloadable?
      src = track.download_url
      format = "."+track.original_format
    else
      src = track.stream_url
      format = ".mp3"
    end
    if src
      filename = File.join dir,track.permalink.to_s+format 
      puts filename
      puts `wget '#{src}?client_id=#{@client.client_id}' -O "#{filename}"` unless File.exists? filename
      TagLib::FileRef.open(filename) do |file|
        tag = file.tag

        tag.title   = track.permalink 
        tag.artist  = track.user.permalink 
        tag.album   = nil
        tag.year    = Date.parse(track.created_at).year
        tag.track   = 0
        tag.genre   = track.genre.downcase
        tag.comment = track.uri
        file.save
      end  # File is automatically closed at block end
    end
  end
end
