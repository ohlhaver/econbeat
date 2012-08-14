class UsersController < ApplicationController
	before_filter :correct_user, only: [:edit, :update]
 def new
  @user = User.new
 end

 def create
  @user = User.new(params[:user])
  if @user.save
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
end
