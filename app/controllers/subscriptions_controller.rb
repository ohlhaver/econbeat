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
    current_user.delay.fb_unsubscribe(author_url(@author))
    respond_to do |format|
      format.html { redirect_to :back, :only_path => true, :notice => "You have unfollowed #{@author.name}." }
      format.js
    end
  end

  def subscribe
    author = Author.find(params[:id])
    current_user.subscribe!(author)
    #current_user.facebook.put_wall_post("started following " + author.name + " via Jurnalo", :link => author_url(author))
    
    #current_user.delay.fb_subscribe_raw(author, author_url(author))
    current_user.delay.fb_subscribe(author_url(author))
    redirect_to :back, :notice => "You are now following #{author.name}."
  end

  def unsubscribe
    author = Author.find(params[:id])
    current_user.unsubscribe!(author)
    current_user.delay.fb_unsubscribe(author_url(author))
    redirect_to :back
  end

  def star
    
    @subscription = Subscription.find(params[:id])
    @subscription.starred=true
    #@subscription.position = 1
    @subscription.save
    current_user.star_author_action(@subscription)
    
    @author = Author.find(@subscription.author_id)
    current_user.delay.fb_star_raw(@author, author_url(@author))
    #current_user.delay.fbstar_author(author_url(@author))
    
    #current_user.delay.fbstar(post_url(@post))
    redirect_to :back, :notice => "You have starred #{@subscription.author.name}."
  end

  def unstar
    @subscription = Subscription.find(params[:id])
    @subscription.starred=nil
    @subscription.save
    #current_user.delay.fbunstar_author(author_url(@subscription.author_id))
    #current_user.delay.fbunstar(post_url(@post))
    redirect_to :back, :notice => "You have unstarred #{@subscription.author.name}."
  end



end
