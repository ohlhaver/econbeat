	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'],:scope => "publish_actions, email"
	end

 