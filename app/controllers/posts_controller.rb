class PostsController < ApplicationController
	include ActionView::Helpers::TextHelper
	before_filter :authorize, only: [:create, :destroy]
	before_filter :correct_user,   only: :destroy

	def new

      @post  = current_user.posts.build if current_user
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
	     
	     	alerted_users = @post.user.followers - @post.utopic.users
	    	if alerted_users != []
		    	PostMailer.delay.notification(@post, alerted_users)
			end
		      flash[:success] = "Post created!"
		      redirect_to root_url
	    else

	       render "new"
   		end
  	end

  def destroy
  	@post.hidden=true
  	@post.save
    #@post.destroy
    redirect_to root_url
  end

	private

	def correct_user
	      @post = current_user.posts.find_by_id(params[:id])
	      rescue
 		  redirect_to root_url
	end

end
