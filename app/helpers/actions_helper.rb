module ActionsHelper
	def ppopover_link author
		

  		if current_user.subscribed?(author)

	  	 	form_for(current_user.subscribed?(author),
	             html: { method: :delete }) do |f| 
	   			f.submit "Unsubscribe", class: "btn btn-link"
			end 

			if current_user.subscribed?(author).starred == true
				
       
          		link_to raw('<i class="icon-star"></i>'), "/subscriptions/#{current_user.subscriptions.find_by_author_id(author.id).id}/unstar", :class => "btn btn-small", title: 'click to unstar', rel: 'tooltip', "data-placement"=>"bottom"
        	else
        		

          		link_to raw('<i class="icon-star-empty"></i>'), "/subscriptions/#{current_user.subscriptions.find_by_author_id(author.id).id}/star", :class => "btn btn-small", title: 'click to star this author', rel: 'tooltip', "data-placement"=>"bottom"
          
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

def sender action
	return action.article.title.to_s	

end


end


