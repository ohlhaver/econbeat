class UsersController < ApplicationController
	before_filter :correct_user, only: [:index, :edit, :update, :destroy]
  before_filter :authorize, only: [:following, :followers, :show, :new]



  respond_to :html, :json

def update
  @user = User.find(params[:id])
  @user.update_attributes(params[:user])
  respond_with @user
end
 #def new
 # @user = User.new(:invitation_token => params[:invitation_token])
 # @user.email = @user.invitation.recipient_email if @user.invitation
 #end

 #def create
 # @user = User.new(params[:user])
 # if @user.save
 #   if @user.invitation
 #     @inviter = User.find(@user.invitation.sender_id) 
 #     @user.follow!(@inviter)
 #   end
 #   cookies.permanent[:auth_token] = @user.auth_token
 #   redirect_to root_url, notice: "Thank you for signing up!"
 # else
 #   render "new"
 # end
 #end

 #def edit
 #   @user = User.find(params[:id])
 #end

 #def update
 #   @user = User.find(params[:id])
 #   if @user.update_attributes(params[:user])
 #     redirect_to root_url, notice: "Profile updated"
 #   else
 #     render 'edit'
 #   end
 # end

	def show


    @user = User.find(params[:id])
    
    
    @friendship = check_friendship(@user)

    


   
      @utopics = @user.utopics.find_all{|i| i.posts.where(:hidden=>nil).count > 0}
      
      @utopic = @user.utopics.find_by_topic_id(params[:topic])
      
      @topics = Topic.find(:all)

      
      @topic = Topic.find(params[:topic]) if params[:topic]
      if params[:topic]
        @posts = @user.posts.where("topic_id = ?", params[:topic]) 
      else
        @posts = @user.posts
      
      end

      

      @favorites = @posts.where(:starred =>true, :hidden=>nil)
      @latest = @posts.where(:starred => nil, :hidden=>nil)
      if current_user == @user
        if @posts.empty?
        flash[:notice] = "Importing your posts from Facebook. Please refresh in a few seconds!" 
        elsif @favorites.empty? && @utopic == nil
        flash[:notice] = "Star your three favorite posts by clicking the star buttons on the right." 
        elsif @utopics.empty?
        flash[:notice] = "Click 'select topic!' underneath any headline to categorize a post."
        end
      end
      
      #@access = true if current_user.facebook.get_object(@user.uid)
      #if @access == true
      @favorites = @favorites.sort_by(&:position)


      @latest = Kaminari.paginate_array(@latest).page(params[:page]).per(50)
  end

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Post.where("user_id = ?", id)
  end

                

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @friendship = check_friendship(@user)
    @users = @user.followed_users.page params[:page]
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @friendship = check_friendship(@user)
    @users = @user.followers.page params[:page]
    render 'show_follow'
  end

  def check_friendship(user)
        unless current_user == user
      check = current_user.facebook.fql_query("SELECT uid2 FROM friend WHERE uid1=me() AND uid2 = #{user.uid}")
      friendship=false if check == []
    end
  end






    

end
