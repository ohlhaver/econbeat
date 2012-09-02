if Rails.env.development?

	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :facebook, '266726516779542', '8400807f19e2ca49f4dea8f47751c3d2', scope: "email"
	end

else

	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :facebook, '198036786877634', 'a9c8a0fdadd66430a25df6724d4c19de', scope: "email"
	end

end
