class AuthorsController < ApplicationController
	before_filter :authorize, only: [:like]
	def show
		@author = Author.find(params[:id])
		@actions = @author.actions
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
		@recommended = @ranked_authors.first(10)

		flash.now[:notice] = "Follow your favorite authors!" unless current_user


	end

	def index
		@authors = List.last.top_authors.split(",").first(250)

	end

	def sitemap
		@authors = List.last.top_authors.split(",")

	end


	def similar
		@author = Author.find(params[:id])
		
		if current_user
			@friends = current_user.followed_users
			@subscribed_friends = @friends.find_all{|i| i.subscribed?(@author)}
		end
		
		@all_authors =[]
		@size = @author.users.size
		@author.users.each do |u|
			@all_authors += (u.authors - Array.wrap(@author))
		end

		@author_hash = @all_authors.inject(Hash.new(0)) { |h,n| h[n] += 1; h }
		@author_hash = @author_hash.sort_by {|author, count| -count}
		@ranked_authors = @author_hash.to_a
		@recommended = @ranked_authors.first(50)
	

	unless current_user

        	flash.now[:notice] = "Start following your favorite authors!</a>"  
    end

    end

    def like
	    
	    @author = Author.find(params[:id])
	

	    #a=current_user.facebook.get_connections("me","og.likes")
	    #s=a.select {|f| f["data"]["object"]["url"] == post_url(@post)}
	    #unless s.empty?
	    #  current_user.facebook.delete_object(s.first["id"])
	    #end
	    #current_user.facebook.put_connections("me", "og.likes", object: post_url(@post))
	    current_user.like_author_action(@author)
	    current_user.delay.fb_author_like(author_url(@author), @author)
	    
	    #LikeMailer.delay.like_it(@post, current_user)
	    #current_user.facebook.put_like(@post.fbaction_id)
	    redirect_to :back, :notice => "Author has been liked."
	    #redirect_back_or root_url#, :notice => "Article has been liked."
	end




end
