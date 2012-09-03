class StaticPagesController < ApplicationController
  def home
  	
    if current_user
      @post  = current_user.posts.build
      #@topics = Topic.find(:all)
      @feed_items = current_user.feed
      #@display_topics=[]
      #  @topics.each do |topic|
      #    topic_feed_items = @feed_items.find_all{|i| i.topic_id == topic.id}
      #    @display_topics = @display_topics << topic if topic_feed_items.size >= 1
      #  end
      #@topics = @display_topics

      #if params[:topic]
        #@feed_items = current_user.feed.where("topic_id = ?", params[:topic])
      #  @feed_items = current_user.feed.find_all{|v| v.topic_id == params[:topic].to_i } 
      #end

        @feed_items = Kaminari.paginate_array(@feed_items).page(params[:page])



    end
 
  end

  def about
  end

  def contact
  end
end
