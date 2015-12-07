=begin
puts "http://api.soundcloud.com/oauth/authorize?oauth_token=#{request_token.token}"
#access_token = OAuth::AccessToken.new(consumer, settings[:access_token_key], settings[:access_token_secret])
puts "code: "
code = gets
soundcloud = Soundcloud.register({:access_token => request_token.get_access_token(:oauth_verifier => code), :site => "http://api.soundcloud.com"})
me = soundcloud.User.find_me
puts me

#131442

class OauthController < ApplicationController
  # This will get a oauth request token from Soundcloud and 
  # then redirect the user to the Soundcloud authorization page.
  # It stores request token and secret in the session to
  # remember it, when it returns to our defined callback page.
  def request_token
    callback_url = url_for :action => :access_token
    request_token = $consumer.get_request_token(:oauth_callback => callback_url)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret    

    redirect_to request_token.authorize_url(:display => 'popup')
  end

  # After authentication at the Soundcloud authorization page,
  # the user will be redirected to this page.
  # We get the access_token and use it to get the Soundcloud user resource
  # and save the user's information in our database before
  # we redirect him to his dashboard.
  def access_token
    request_token = OAuth::RequestToken.new($consumer, session[:request_token], session[:request_token_secret])
    access_token = request_token.get_access_token

    sc = Soundcloud.register({:access_token => access_token, :site => "http://api.#{$sc_host}"})
    me = sc.User.find_me
    sc_account = SoundcloudAccount.create :username => me.username, :oauth_token => access_token.token, :oauth_token_secret => access_token.secret

    redirect_to  "/sc-connect/close.html?username=#{CGI::escape(sc_account.username)}&soundcloud_account_id=#{sc_account.id}"
  end 
end
=end


#@@client = SC::Client.new('sandbox-soundcloud.com', 'tabcwIWB7dv9KT5Sy2rQ', 'zFMrmC87pisbnEY3lAG7BlaghEPgqDKGl4iXNYd0', 'api.') 
# Create a Soundcloud OAuth consumer token object
#
# # Create an OAuth access token object
# access_token = OAuth::AccessToken.new(sc_consumer, 'YOUR_OAUTH_ACCESS_TOKEN', 'YOUR_OAUTH_ACCESS_SECRET')
#
# # Create an authenticated Soundcloud client, based on the access token
# sc_client = Soundcloud.register({:access_token => access_token})
#
# # Get the logged in user 
# my_user = sc_client.User.find_me
#
# # Display his full name
# p "Hello, my name is #{my_user.full_name}"
#


# Find the 10 hottest tracks
#
# # and display their titles
# p '==the 10 hottest tracks=='gg
#
#

