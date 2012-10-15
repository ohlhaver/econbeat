module ActionsHelper
	def pover_link author
		

  	 if current_user.subscribed?(author)

  	 	form_for(current_user.subscriptions.find_by_author_id(author),
             html: { method: :delete },
             remote: true) do |f| 
   f.submit "Unfollow", class: "btn btn-link"
	end 
	else
		form_for(current_user.subscriptions.build(author_id: author.id),
             remote: true) do |f|
 f.hidden_field :author_id

  f.submit "Follow", class: "btn btn-link" 
end
	end
end


def popover_link author
		

  	 if current_user.subscribed?(author)

  	 	 link_to "unsubscribe", :controller=>"subscriptions", :action => "unsubscribe", :id => author.id

	else
		link_to "subscribe", :controller=>"subscriptions", :action => "subscribe", :id => author.id

	end
end
end


