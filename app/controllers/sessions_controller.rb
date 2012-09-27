class SessionsController < ApplicationController
	before_filter :authorize, only: [:new]
	
	def create
	    user = User.from_omniauth(env["omniauth.auth"])
	    session[:user_id] = user.id
	    user.delay.sync_fb
	    #user.load_friends_posts
	    redirect_back_or root_url
  	end

  	def destroy
	    session[:user_id] = nil
	    redirect_to root_url
  	end



	def new
	end

	#def create
	#  user = User.find_by_email(params[:email])
	#  if user && user.authenticate(params[:password])
	#        if params[:remember_me]
	#	      cookies.permanent[:auth_token] = user.auth_token
	#	    else
	#	      cookies[:auth_token] = user.auth_token
	#	    end
	#    redirect_back_or root_url
	#  else
	#    flash.now.alert = "Email or password is invalid"
	#    render "new"
	#  end
	#end

	#def old_destroy
	#  cookies.delete(:auth_token)
	#  redirect_to root_url, notice: "Logged out!"
	#end


end
