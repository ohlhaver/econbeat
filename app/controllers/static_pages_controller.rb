class StaticPagesController < ApplicationController
  def home
  	
    if current_user
      @post  = current_user.posts.build
      @topics = Topic.find(:all)
     
      if params[:topic]
        @feed_items = current_user.feed.where("topic_id = ?", params[:topic]) 
      else
        @feed_items = current_user.feed
      end
    end
 
  end

  def about
  end

  def contact
  end
end
