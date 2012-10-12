class ActionsController < ApplicationController
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

	    #@post.destroy
	    redirect_to :back
  	end


  	private
  	def correct_user
	      @action = current_user.actions.find_by_id(params[:id])
	      rescue
 		  redirect_to root_url
	end



end
