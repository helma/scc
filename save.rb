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
	
	@next_track = session[:me].favorites.sort_by{ rand }.first
	@track = Track.first(:sc_id => params[:id]) or @track = Track.create(:sc_id => params[:id])
	@styles = @track.styles.collect{|s| s.name}
	@played = @track.played
	@track.played += 1
	@track.save
	haml :play
end


