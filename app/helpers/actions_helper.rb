module ActionsHelper

	def popover_link author
		@author=author
		render 'authors/subscribe_form'

	end


def today author
	@todays_actions=author.actions.where("actions.created_at >= :time", {:time => 1.day.ago})
	render 'authors/today'	 
	
end

def follow author
	"Follow " + author.name 	 
	
end

def unfollow author
	"Unfollow " + author.name 	 
	
end

def sender action
	return action.article.title.to_s	

end


end


