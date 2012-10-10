class ActionsController < ApplicationController
		def index
	  @authors = Author.search params[:q], :match_mode => :any
	  #@articles = Article.search params[:q], :match_mode => :any, :order => :created_at,
	  #:sort_mode => :desc
	  	  @actions = Action.search params[:q], :with => {:action_type => [7,1]}, :match_mode => :any, :order => :created_at,
	  :sort_mode => :desc
	  @actions = Kaminari.paginate_array(@actions).page(params[:page]).per(50)
	end
end
