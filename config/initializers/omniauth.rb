if Rails.env.development?

	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :facebook, '266726516779542', '8400807f19e2ca49f4dea8f47751c3d2', scope: "email,read_stream"
	end

end