class StaticPagesController < ApplicationController
  def home
  	
    if current_user
      @post  = current_user.posts.build
      @feed_items = current_user.feed 
    end
 
  end

  def about
  end

  def contact
  end
end
