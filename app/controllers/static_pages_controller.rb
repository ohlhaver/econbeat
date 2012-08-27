class StaticPagesController < ApplicationController
  def home
  	
    if current_user
      @post  = current_user.posts.build
      @topics = Topic.find(:all)

      if params[:topic]
        #@feed_items = current_user.feed.where("topic_id = ?", params[:topic])
        @feed_items = current_user.feed.find_all{|v| v.topic_id == params[:topic].to_i } 
      else
        @feed_items = current_user.feed
      end
        @feed_items = Kaminari.paginate_array(@feed_items).page(params[:page])
    end
 
  end

  def about
  end

  def contact
  end
end
