class PostsController < ApplicationController
	include ActionView::Helpers::TextHelper
	before_filter :authorize, only: [:create, :destroy]
	before_filter :correct_user,   only: :destroy


	def create

	    @post = current_user.posts.build(params[:post])
	    @doc = Pismo::Document.new(@post.url)
	    @post.headline = @doc.title
	    @post.description = @doc.description
	    @post.author = @doc.author
	    @post.topic_id = 0 if @post.topic_id == nil
	    #@utopic = @post.topic_id
	    @utopic = Utopic.find_by_user_id_and_topic_id(current_user.id, @post.topic_id) || Utopic.create(:user_id => current_user.id, :topic_id => @post.topic_id)

	    @post.utopic_id = @utopic.id

	    if @post.save
	     

	      flash[:success] = "Post created!"
	      redirect_to root_url
	    else
	      @feed_items = []
      	  render 'static_pages/home'
   		end
  	end

  def destroy
    @post.destroy
    redirect_to root_url
  end

	private

	def correct_user
	      @post = current_user.posts.find_by_id(params[:id])
	      rescue
 		  redirect_to root_url
	end

end
