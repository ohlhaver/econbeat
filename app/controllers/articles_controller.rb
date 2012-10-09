class ArticlesController < ApplicationController
	def index
		@authors = Author.search params[:q], :match_mode => :any
	  @articles = Article.search params[:q], :match_mode => :any, :order => :created_at,
	  :sort_mode => :desc
	end

	def like
	    
	    @article = Article.find(params[:id])
	    like = Like.new
	      like.user_id = current_user.id
	      like.article_id = @article.id
	    like.save
	    current_user.like_article_action(like)

	    #a=current_user.facebook.get_connections("me","og.likes")
	    #s=a.select {|f| f["data"]["object"]["url"] == post_url(@post)}
	    #unless s.empty?
	    #  current_user.facebook.delete_object(s.first["id"])
	    #end
	    #current_user.facebook.put_connections("me", "og.likes", object: post_url(@post))
	    current_user.delay.fblike(post_url(@post), @post)
	    LikeMailer.delay.like_it(@post, current_user)
	    #current_user.facebook.put_like(@post.fbaction_id)
	    redirect_to :back, :notice => "Article has been liked."
	    #redirect_back_or root_url#, :notice => "Article has been liked."
	end


end
