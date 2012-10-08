class ArticlesController < ApplicationController
def index
	@authors = Author.search params[:q], :match_mode => :any
  @articles = Article.search params[:q], :match_mode => :any, :order => :created_at,
  :sort_mode => :desc
end

end
