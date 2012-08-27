class FiltersController < ApplicationController

before_filter :authorize




  def new
  	@utopic = Utopic.find(params[:utopic])

  	if params[:filter] == nil

		  	
			
		   Filter.create!(:user_id => current_user.id, :utopic_id => @utopic.id)
		   redirect_to :controller => "users", :action => "show", :id => @utopic.user_id, :only_path => true
		   #   respond_to do |format|
		   #   format.html { redirect_to @user }
		   #   format.js
		   # end
    
  	else


	  	@filter = Filter.find(params[:filter])
	   @filter.destroy
	   redirect_to :controller => "users", :action => "show", :id => @utopic.user_id, :only_path => true
    end
 
 end
end