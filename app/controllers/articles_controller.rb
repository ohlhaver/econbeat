class ArticlesController < ApplicationController
	before_filter :authorize, only: [:like]


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
	    
	    current_user.delay.fb_article_like(article_url(@article), @article)
	    
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

		if current_user
			@friends = current_user.followed_users
			@subscribed_friends = @friends.find_all{|i| i.subscribed?(@author)}.first(10)
		end
		@all_authors =[]
		@size = @author.users.size
		@author.users.each do |u|
			@all_authors += (u.authors - Array.wrap(@author))
		end

		@author_hash = @all_authors.inject(Hash.new(0)) { |h,n| h[n] += 1; h }
		@author_hash = @author_hash.sort_by {|author, count| -count}
		@ranked_authors = @author_hash.to_a
		@recommended = @ranked_authors.first(3)

		unless current_user
        	flash.now[:notice] = "Start following all your favorite authors.<br> <a href=\"/auth/facebook\">Login now via Facebook! (It's free.)</a>" 
    	end

	end	

	def comment
		@article = Article.find(params[:id])
		@author = @article.catcher.author
		render :action => :show, :layout => false
	end

end
