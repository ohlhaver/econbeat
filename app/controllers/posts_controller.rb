class PostsController < ApplicationController
	include ActionView::Helpers::TextHelper

	before_filter :authorize, only: [:create, :destroy, :share, :add_comment, :new, :like]
	before_filter :correct_user,   only: [:destroy, :star, :unstar]
	before_filter :correct_post_user,   only: [:update]
	respond_to :html, :json


def show
	@post = Post.find(params[:id])

	##@fb_action_id = find_fbaction_id(@post)
  #if @post.fbaction_id && current_user
  #  @object = current_user.facebook.get_object(@post.fbaction_id)
  #  if @object
  #    @comments_object = @object["comments"]
  #      @comments= @comments_object["data"] if @comments_object
  #
  #  else
  #    @post.box= false
  #  end
  #else
  #  @post.box= false
  #end
  if @post.fbaction_id && current_user
    begin
      object = current_user.facebook.get_object(@post.fbaction_id)
    rescue

    else
      if object && object["comments"]
        fb_comments = object["comments"]["data"]
        if fb_comments
          fb_comments.each do |c| 
            comment = Comment.new
            comment.text = c["message"]
            comment.user_id = User.find_by_uid(c["from"]["id"]).id if User.find_by_uid(c["from"]["id"])
            comment.post_id = @post.id
            comment.fbid = c["id"]
            comment.created_at = c["created_time"]
            comment.save
          end
        end
      end
    end

  end
    

	@comments = @post.comments
end

def add_comment
@post = Post.find(params[:id])
  comment = Comment.new
    comment.text = params[:comment]
    comment.user_id = current_user.id
    comment.post_id = @post.id
    comment.fbid = Time.now.to_i.to_s + " " + current_user.id.to_s 
  comment.save

  #current_user.comment_action(comment)
  PostMailer.delay.comment(@post, current_user, comment.text) unless @post.user == current_user
  if @post.commenters
    PostMailer.delay.also_comment(@post, current_user, comment.text)
  end

  
  if @post.fbaction_id
    begin
     object = current_user.facebook.get_object(@post.fbaction_id)
    rescue
    else
     if object
  
  
      	a=current_user.facebook.put_comment(@post.fbaction_id, params[:comment] )
        comment.fbid = a["id"]
        comment.save
     end
    end
  end
  #count = current_user.facebook.get_object(@post.fbaction_id)["comments"]["data"].count
  #@post.comments_count= count
  #@post.save
  redirect_to :back
end




  def like
    
    @post = Post.find(params[:id])
    like = Like.new
      like.user_id = current_user.id
      like.post_id = @post.id
    like.save
    current_user.like_post_action(like)

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



	def new

     #@post  = current_user.posts.build if current_user
	end

  def preview
    @post = Post.find(params[:id])
    @new_post = Post.new
    @new_post.user_id = current_user.id
    @new_post.url = @post.url
    @new_post.headline = @post.headline
    @new_post.description = @post.description
    @new_post.author = @post.author
    @new_post.topic_id = @post.topic_id
    @new_post.picture = @post.picture
    #@new_post.fbid = Time.now.to_i.to_s + " " + current_user.id.to_s 
    @new_post.via_id = @post.user_id
   #   @utopic = Utopic.find_by_user_id_and_topic_id(current_user.id, @post.topic_id) || Utopic.create(:user_id => current_user.id, :topic_id => @post.topic_id)
   # @new_post.utopic_id = @utopic.id
     #@new_post.save
    respond_to do |format|
      format.html
      format.js
    end

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
    if @post.headline == nil
  	
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
			     
			    #@post.fbid = @post.url
			  end

		    @post.topic_id = 0 if @post.topic_id == nil
    end
		    #@utopic = @post.topic_id
		@utopic = Utopic.find_by_user_id_and_topic_id(current_user.id, @post.topic_id) || Utopic.create(:user_id => current_user.id, :topic_id => @post.topic_id)
		@post.utopic_id = @utopic.id	
    @post.fbid = Time.now.to_i.to_s + " " + current_user.id.to_s  
  end
  


  if @post.save
      current_user.post_action(@post)
  		current_user.delay.fbpost(post_url(@post), @post) if @post.facebook == true
     
    if @post.email == true
     	alerted_users = @post.user.followers - @post.utopic.users
    	if alerted_users != []
      	PostMailer.delay.notification(@post, alerted_users)
  	 end
    end
        flash[:success] = "Post created!"
        redirect_to @post
  else
       flash[:error] = "Invalid url!"
       redirect_to root_url

     end
end

  def destroy
  	@post.hidden=true
    if @post.starred==true
      @post.starred=nil
      current_user.delay.fbunstar(post_url(@post))
    end
   
  	@post.save

    #@post.destroy
    redirect_to :back
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
    @post.position = 1
  	@post.save
  	
  	current_user.delay.fbstar(post_url(@post))
  	redirect_to current_user, :notice => "Article has been starred."
  end

  def unstar
  	@post = Post.find(params[:id])
  	@post.starred=nil
  	@post.save
  	current_user.delay.fbunstar(post_url(@post))
  	redirect_to current_user
  end



  def new_comment
  end

    def find_fbaction_id(post)
      if Rails.env.development?  
        user = post.user
     a=user.facebook.get_connections("me","EconBloggers_local:share")
    else
      a=user.facebook.get_connections("me","EconBloggers:share")
    end
    s=a.select {|f| f["data"]["article"]["url"] == post_url(post)}
    return s.first["id"] if s != []


  end

def sort
  params[:post].each_with_index do |id, index|
    Post.update_all({position: index+1}, {id: id})
  end
  render nothing: true
end




	private

	def correct_user
	      @post = current_user.posts.find_by_id(params[:id])
	      rescue
 		  redirect_to root_url
	end

end
