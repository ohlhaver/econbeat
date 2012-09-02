class FacebookUpdatesController < ApplicationController
	VERIFY_TOKEN = "wekghonepkehidmo"

  layout nil

  def create
  	real_time_update!(params)
    render :text=>'success'
  end

  def real_time_update!(params)
  	@update = FacebookUpdate.new
  	@update.uid = params["entry"][0]["uid"]
	@update.save
  end


  def index
    Rails.logger.info("FacebookUpdatesController verification")
    render :text=>Koala::Facebook::RealtimeUpdates.meet_challenge(params, VERIFY_TOKEN)
  end
end
