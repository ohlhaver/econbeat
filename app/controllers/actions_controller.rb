class ActionsController < ApplicationController
	before_filter :authorize, only: [:add_comment, :show]
	before_filter :correct_user,   only: [:destroy]
	def index
	  @authors = Author.search params[:q], :match_mode => :any
	  #@articles = Article.search params[:q], :match_mode => :any, :order => :created_at,
	  #:sort_mode => :desc
	  	  @actions = Action.search params[:q], :with => {:action_type => [7,1]}, :match_mode => :any, :order => :created_at,
	  :sort_mode => :desc
	  @actions = Kaminari.paginate_array(@actions).page(params[:page]).per(50)
	end

	def destroy
	  	@action.hidden=true
	  	@action.save

	    #@action.destroy
	    redirect_to :back
  	end

  	def show
		  		@action = Action.find(params[:id])
		  		if @action.fbaction_id && current_user
		    begin
		      object = current_user.facebook.get_object(@action.fbaction_id)
		    rescue

		    else
		      if object && object["comments"]
		        fb_comments = object["comments"]["data"]
		        if fb_comments
		          fb_comments.each do |c| 
		            comment = Comment.new
		            comment.text = c["message"]
		            comment.user_id = User.find_by_uid(c["from"]["id"]).id if User.find_by_uid(c["from"]["id"])
		            comment.action_id = @action.id
		            comment.fbid = c["id"]
		            comment.created_at = c["created_time"]
		            comment.save
		          end
		        end
		      end
		    end

		  end
		    

			@comments = @action.comments
  	end

  	def add_comment
		@action = Action.find(params[:id])
		  comment = Comment.new
		    comment.text = params[:comment]
		    comment.user_id = current_user.id
		    comment.action_id = @action.id
		    comment.article_id = @action.article_id
		    comment.fbid = Time.now.to_i.to_s + " " + current_user.id.to_s 
		  comment.save

		  #current_user.comment_action(comment)
		  PostMailer.delay.comment(@action, current_user, comment.text) unless @action.user == current_user
		  if @action.commenters
		    PostMailer.delay.also_comment(@action, current_user, comment.text)
		  end

		  
		  if @action.fbaction_id
		    begin
		     object = current_user.facebook.get_object(@action.fbaction_id)
		    rescue
		    else
		     if object
		  
		  
		      	a=current_user.facebook.put_comment(@action.fbaction_id, params[:comment] )
		        comment.fbid = a["id"]
		        comment.save
		     end
		    end
		  end
		  #count = current_user.facebook.get_object(@action.fbaction_id)["comments"]["data"].count
		  #@action.comments_count= count
		  #@action.save
		  redirect_to :back
	end

  	private
  	def correct_user
	      @action = current_user.actions.find_by_id(params[:id])
	      rescue
 		  redirect_to root_url
	end



end
