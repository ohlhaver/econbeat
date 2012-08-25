class UsersController < ApplicationController
	before_filter :correct_user, only: [:index, :edit, :update, :destroy]
  before_filter :authorize, only: [:following, :followers]

 def new
  @user = User.new(:invitation_token => params[:invitation_token])
  @user.email = @user.invitation.recipient_email if @user.invitation
 end

 def create
  @user = User.new(params[:user])
  if @user.save
    @inviter = User.find(@user.invitation.sender_id)
    @user.follow!(@inviter)
    session[:user_id] = @user.id
    redirect_to root_url, notice: "Thank you for signing up!"
  else
    render "new"
  end
 end

 def edit
    @user = User.find(params[:id])
 end

 def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to root_url, notice: "Profile updated"
    else
      render 'edit'
    end
  end

	def show
    @user = User.find(params[:id])
    @posts = @user.posts.page params[:page]
  end

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Post.where("user_id = ?", id)
  end

                

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.page params[:page]
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.page params[:page]
    render 'show_follow'
  end

    

end
