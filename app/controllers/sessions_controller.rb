require 'net/https'

class SessionsController < ApplicationController

  def create
        
    url = "https://api.pocketsmith.com/v2/oauth/access_token"
    client = HTTPClient.new
    body = { 
      grant_type: "authorization_code",
      client_id: Rails.application.secrets.pocketsmith_client_id,
      client_secret: Rails.application.secrets.pocketsmith_client_secretk,
      redirect_uri: "https://digits.willjasen.com/pocketsmith/callback",
      code: params[:code]
    }
    
    if body[:client_secret].present?
      res = client.post(url, body)
      auth = JSON.parse(res.content)
    else
      puts "client_secret is nil..."
    end
   
    response = Faraday.get do |req|
      req.url "https://api.pocketsmith.com/v2/me" 
      req.headers['Authorization'] = "Bearer #{auth['access_token']}"
      puts req.headers  
    end

    response = JSON.parse(response.body)
    
    user = User.find_by_uid(response['id'])
   
    if user
      puts "The user already exists!!"
    else
      user = User.create(
               access_token: auth['access_token'],
               token_type: auth['token_type'],
               refresh_token: auth['refresh_token'],
               uid: response['id'],
               login: response['login']
             )
    end

    session[:uid] = user.uid

    redirect_to '/', :notice => "Signed in!"
    
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

end
