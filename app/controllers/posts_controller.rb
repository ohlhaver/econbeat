class PostsController < ApplicationController
	include ActionView::Helpers::TextHelper

	before_filter :authorize, only: [:create, :destroy, :share]
	before_filter :correct_user,   only: [:destroy, :star, :unstar]
	before_filter :correct_post_user,   only: [:update]
	respond_to :html, :json


def show
	@post = Post.find(params[:id])
end



	def new

      @post  = current_user.posts.build if current_user
	end


def update
  @post = Post.find(params[:id])
  @post.update_attributes(params[:post])
  				    @utopic = Utopic.find_by_user_id_and_topic_id(current_user.id, @post.topic_id) || Utopic.create(:user_id => current_user.id, :topic_id => @post.topic_id)

				    @post.utopic_id = @utopic.id
				    @post.save
  respond_with @post
end

	def create

	    @post = current_user.posts.build(params[:post])
	    	unless @post.url == ""
			    @doc = Pismo::Document.new(@post.url)
			    	unless @doc == nil
			     
					    @headline = @doc.titles[1]

					    if @headline == nil
					    	@headline = @doc.titles[2] 
					    elsif @headline.length < 20
					    	@headline = @doc.titles[2] 
					    end

					    if @headline == nil
					    	@headline = @doc.title 
					    elsif @headline.length < 20
					    	@headline = @doc.title 
					    end



					    @post.headline = @headline[0,250] if @headline != nil
					    @post.description = @doc.description[0,250] if @doc.description != nil
					    @post.author = @doc.author[0,250] if @doc.author != nil
					    @post.fbid = Time.now.to_i.to_s + " " + current_user.id.to_s 
					    #@post.fbid = @post.url
					end
				    @post.topic_id = 0 if @post.topic_id == nil
				    #@utopic = @post.topic_id
				    @utopic = Utopic.find_by_user_id_and_topic_id(current_user.id, @post.topic_id) || Utopic.create(:user_id => current_user.id, :topic_id => @post.topic_id)

				    @post.utopic_id = @utopic.id

				  
		    end
		

	    if @post.save

  			current_user.delay.fbpost(post_url(@post))
	     
	     	alerted_users = @post.user.followers - @post.utopic.users
	    	if alerted_users != []
		    	PostMailer.delay.notification(@post, alerted_users)
			end
		      flash[:success] = "Post created!"
		      redirect_to current_user
	    else
	       render "new"
   		end
  	end

  def destroy
  	@post.hidden=true
  	@post.save
    #@post.destroy
    redirect_to current_user
  end

  def star
  	@starred = current_user.posts.where(:starred =>true)
  	if @starred.size > 2
  		@starred.last.starred=nil
  		@starred.last.save
  		current_user.delay.fbunstar(post_url(@starred.last))
  	end
  	@post = Post.find(params[:id])
  	@post.starred=true
  	@post.save
  	
  	current_user.delay.fbstar(post_url(@post))
  	redirect_to current_user, :notice => "Article has been starred."
  end

  def unstar
  	@post = Post.find(params[:id])
  	@post.starred=nil
  	@post.save
  	current_user.delay.fbunstar(post_url(@post))
  	redirect_to current_user, :notice => "Article has been unstarred."
  end

  def share
  	@post = Post.find(params[:id])
  	@new_post = Post.new
  	@new_post.user_id = current_user.id
  	@new_post.url = @post.url
  	@new_post.headline = @post.headline
  	@new_post.description = @post.description
  	@new_post.author = @post.author
  	@new_post.topic_id = @post.topic_id
  	@new_post.picture = @post.picture
  	@new_post.fbid = @post.fbid + current_user.id.to_s
  	@new_post.via_id = @post.user_id
  	@utopic = Utopic.find_by_user_id_and_topic_id(current_user.id, @post.topic_id) || Utopic.create(:user_id => current_user.id, :topic_id => @post.topic_id)
				    @new_post.utopic_id = @utopic.id
				    @new_post.save
	current_user.delay.fbpost(post_url(@new_post))
  	redirect_to current_user
  end


	private

	def correct_user
	      @post = current_user.posts.find_by_id(params[:id])
	      rescue
 		  redirect_to root_url
	end

end
