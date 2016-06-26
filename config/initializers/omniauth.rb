module OmniAuth
  module Strategies
    autoload :Pocketsmith, Rails.root.join('lib', 'strategies', 'pocketsmith') 
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :Pocketsmith, Rails.application.secrets.pocketsmith_client_id, {
      redirect_uri: "https://digits.willjasen.com/pocketsmith/callback",
      scope: "user.read"
    }
end
