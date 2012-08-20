class StaticPagesController < ApplicationController
  def home
  	
    if current_user
      @post  = current_user.posts.build
      @feed_items = current_user.feed.page params[:page]
    end
 
  end

  def about
  end

  def contact
  end
end
