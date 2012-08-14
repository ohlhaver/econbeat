class ApplicationController < ActionController::Base
  protect_from_forgery

private

	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	helper_method :current_user

	def authorize
	  redirect_to login_url, alert: "Not authorized" if current_user.nil?
	end

	def correct_user
      @user = User.find(params[:id])
      redirect_to root_path, alert: "Not authorized" unless current_user == @user
    end

end
