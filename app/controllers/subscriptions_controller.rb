class SubscriptionsController < ApplicationController
	before_filter :authorize

  def create
    @author = Author.find(params[:subscription][:author_id])
    current_user.subscribe!(@author)
    respond_to do |format|
      format.html { redirect_to :back, :only_path => true }
      format.js
    end
  end

  def destroy
    @author = Subscription.find(params[:id]).author
    current_user.unsubscribe!(@author)
    respond_to do |format|
      format.html { redirect_to :back, :only_path => true }
      format.js
    end
  end

  def subscribe
    author = Author.find(params[:id])
    current_user.subscribe!(author)
    redirect_to :back
  end

  def unsubscribe
    author = Author.find(params[:id])
    current_user.unsubscribe!(author)
    redirect_to :back
  end

  def star
    
    @subscription = Subscription.find(params[:id])
    @subscription.starred=true
    #@subscription.position = 1
    @subscription.save
    current_user.star_author_action(@subscription)
    
    #current_user.delay.fbstar(post_url(@post))
    redirect_to authors_user_path(current_user), :notice => "Author has been starred."
  end

  def unstar
    @subscription = Subscription.find(params[:id])
    @subscription.starred=nil
    @subscription.save
    #current_user.delay.fbunstar(post_url(@post))
    redirect_to authors_user_path(current_user)
  end



end
