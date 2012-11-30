class ApplicationController < ActionController::Base
  protect_from_forgery

private




	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id]

	end
	helper_method :current_user

	#def current_user
	#  @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
	#end
	#helper_method :current_user
	def check_for_canvas
		if params[:r] == "facebook"
			authorize
		end

	end

	def authorize
		if current_user.nil?	
		  store_location
		  redirect_to "/auth/facebook" 
		end
	end

	def correct_user
      @user = User.find(params[:id])
      redirect_to root_path, alert: "Not authorized" unless current_user == @user
    end

    def correct_post_user
      @post = Post.find(params[:id])
      redirect_to root_path, alert: "Not authorized" unless current_user == @post.user
    end


    def redirect_back_or(default)
   	 redirect_to(session[:return_to] || default)
   	 session.delete(:return_to)
  	end

	def store_location
	  session[:return_to] = request.url
	end


end
