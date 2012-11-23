class StaticPagesController < ApplicationController
  before_filter :authorize, only: [:fb_new, :add_message]
  def home
    if current_user
      #@starred_actions = current_user.starred_author_action_feed.where("created_at >= :time", {:time => 1.day.ago}).sort_by{|e| -e[:id]}
      @starred_actions = current_user.starred_author_action_feed.find_all{|i| i.created_at >= 12.hours.ago}.sort_by{|e| -e[:id]}
      #@user_actions = current_user.user_action_feed
      #@unique_user_actions =[]
      #@unique_user_actions += Array.wrap(@user_actions.first)
      #@user_actions.each do |a|
      #  @unique_user_actions += Array.wrap(a) if @unique_user_actions.find_all{|i| i.article_id == a.article_id}==[]
      #end

      # @actions = (@unique_user_actions + current_user.author_action_feed - @starred_actions).sort_by{|e| -e[:id]}
      @author_actions = current_user.author_action_feed
      @actions =  (current_user.user_action_feed + @author_actions - @starred_actions).sort_by{|e| -e[:id]}
     

      #@user_actions=current_user.user_action_feed
      


      if @author_actions.empty?
        flash.now[:notice] = "Follow your favorite economists!" unless flash[:notice]
       elsif current_user.starred_subscriptions.empty?
        flash.now[:notice] = "Star your favorite economists by clicking the star buttons on the right." unless flash[:notice]
     #   elsif @utopics.empty?
     #   flash[:notice] = "Click 'select topic!' underneath any headline to categorize a post."
     #   end
      end
         @starred_actions = Kaminari.paginate_array(@starred_actions).page(params[:page]).per(50)
          @actions = Kaminari.paginate_array(@actions).page(params[:page]).per(50)
        #  @user_actions = Kaminari.paginate_array(@user_actions).page(params[:page]).per(50)

          @recommended, @popular = current_user.recommended
          

    else

      @actions, @popular = Action.latest_from_top_authors
      @actions = Kaminari.paginate_array(@actions).page(params[:page]).per(50)
      
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
