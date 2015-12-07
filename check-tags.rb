#!/usr/bin/env ruby
require 'fileutils'
include FileUtils
require 'taglib'
require File.join(File.dirname(__FILE__),"login.rb")
sc_dir = "./soundcloud"
@tags = {}
Dir["#{sc_dir}/*/*"].each do |f|
  TagLib::FileRef.open(f) do |file|
    tag = file.tag
    tags = [ :title, :artist, :year, :genre, :comment ]
    tags.each do |t|
      @tags[t] ||= []
      res = tag.send(t)
      #puts "#{f}: No #{t}" unless res
      @tags[t] << res if res
    end
  end  # File is automatically closed at block end
end
#@tags.each do |t,d|
  #puts "#{t}: #{d.sort.uniq.join(", ")}" if [:artist,:genre].include? t
#end
#puts
puts @tags[:genre].collect{|g| g.split(/[\/,\s]/)}.flatten.sort.uniq.join(", ")
