module ApplicationHelper
	def build_a_post
		@post  = current_user.posts.build
	end

end
