class FacebookUpdatesController < ApplicationController
	VERIFY_TOKEN = "wekghonepkehidmo"

  layout nil

  def create
    FacebookUpdate.create(:uid => params["entry"][0]["uid"])
    render :text=>'success'
  end

  def index
    Rails.logger.info("FacebookUpdatesController verification")
    render :text=>Koala::Facebook::RealtimeUpdates.meet_challenge(params, VERIFY_TOKEN)
  end
end
