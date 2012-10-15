module ActionsHelper
	def ppopover_link author
		

  		if current_user.subscribed?(author)

	  	 	form_for(current_user.subscriptions.find_by_author_id(author),
	             html: { method: :delete }) do |f| 
	   			f.submit "Unsubscribe", class: "btn btn-link"
			end 
		else
			form_for(current_user.subscriptions.build(author_id: author.id)) do |f|
 				f.hidden_field :author_id

  				f.submit "Subscribe", class: "btn btn-link" 
			end
		end
	end

	def popover_link author
		@author=author
		render 'authors/subscribe_form'

	end



def ppopover_link author
		

  	 if current_user.subscribed?(author)

  	 	 button_to "unsubscribe", :controller=>"subscriptions", :action => "unsubscribe", :id => author.id, :class => "btn btn-link"

	else
		button_to "subscribe", :controller=>"subscriptions", :action => "subscribe", :id => author.id, :class => "btn btn-link"

	end
end
end


