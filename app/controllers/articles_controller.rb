class ArticlesController < ApplicationController


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
	    
	    #current_user.delay.fblike(article_url(@article), @article)
	    
	    #LikeMailer.delay.like_it(@post, current_user)
	    #current_user.facebook.put_like(@post.fbaction_id)
	    redirect_to :back, :notice => "Article has been liked."
	    #redirect_back_or root_url#, :notice => "Article has been liked."
	end


	def show
		@article = Article.find(params[:id])
		@author = @article.catcher.author
		@action = Array.wrap(@article.catcher.author.actions.find_by_article_id(params[:id]))
		@actions = @article.catcher.author.actions - @action
		@actions = Kaminari.paginate_array(@actions).page(params[:page]).per(50)
	end	

end
