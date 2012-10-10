class AuthorsController < ApplicationController
	def show
		@author = Author.find(params[:id])
		@actions = @author.actions
		@actions = Kaminari.paginate_array(@actions).page(params[:page]).per(50)
	end
end
