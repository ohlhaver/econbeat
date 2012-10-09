class SubscriptionsController < ApplicationController
	before_filter :authorize

  def create
    @author = Author.find(params[:subscription][:author_id])
    current_user.subscribe!(@author)
    respond_to do |format|
      format.html { redirect_to @author, :only_path => true }
      format.js
    end
  end

  def destroy
    @author = Subscription.find(params[:id]).author
    current_user.unsubscribe!(@author)
    respond_to do |format|
      format.html { redirect_to @author, :only_path => true }
      format.js
    end
  end
end
