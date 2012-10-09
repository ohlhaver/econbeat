class StaticPagesController < ApplicationController
  before_filter :authorize, only: [:fb_new]
  def home
    if current_user
      @articles = current_user.articles
      @topics = Topic.find(:all)
      @topics = @topics.find_all{|i| i.posts.where(:hidden=>nil).count > 0}
      @feed_items = current_user.feed
      @display_topics=[]
        @topics.each do |topic|
          topic_feed_items = @feed_items.find_all{|i| i.topic_id == topic.id}
          @display_topics = @display_topics << topic if topic_feed_items.size >= 1
        end
      @topics = @display_topics

      if params[:topic]
        #@feed_items = current_user.feed.where("topic_id = ?", params[:topic])
        @feed_items = current_user.feed.find_all{|v| v.topic_id == params[:topic].to_i } 
      end

     # @feed_items.each do |i|
     #     if i.fbaction_id 
     #       object = current_user.facebook.get_object(i.fbaction_id) 
     #       if object
     #         c = object["comments"]
     #         i.comments = c["data"] if c
     #         #i.count = c["count"] if c
     #       else
     #         i.box= false
     #       end
     #     else
     #       i.box= false
     #     end


      #end

        @feed_items = Kaminari.paginate_array(@feed_items).page(params[:page]).per(50)



    end
 
  end

  def fb_new
    redirect_to root_url

  end

  def privacy
  end
  
  def terms
  end

  def about
  end

  def add_message
    @message = params[:message]
    @user = current_user
    unless @message ==nil
       UserMailer.delay.send_message(@message, @user)
       redirect_to root_url, :notice => "Message submitted."
    end
  end

  def contact
  end
end
