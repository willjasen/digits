require 'net/https'

class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
   
    puts "Inspect: " + auth 
   
    url = "https://api.pocketsmith.com/v2/oauth/access_token"
    client = HTTPClient.new
    body = { 
      grant_type: "authorization_code",
      client_id: Rails.application.secrets.pocketsmith_client_id,
      client_secret: Rails.application.secrets.pocketsmith_client_secret,
      redirect_uri: "https://digits.willjasen.com/pocketsmith/callback",
      code: :code
    }
    
    res = client.post(url, body)
    
    redirect_to '/', :notice => "Signed in!"
    #rl = URI.parse('https://api.pocketsmith.com/v2/oauth/access_token')
    #req = Net::HTTP::Post.new(url.path)
    #req.form_data = data
    #con = Net::HTTP.new(url.host, url.port)
    #con.use_ssl = true
    #con.start {|http| http.request(req)}    

    #auth["code"]

    #user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    #session[:user_id] = user.id
    #redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

end
