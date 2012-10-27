task :daily_mail => :environment do
  puts "start mailing..."

  User.all.each do |u|
  	actions = u.author_action_feed.find_all{|i| i.created_at >= 1.day.ago}.sort_by{|e| -e[:id]}
  	if actions.size > 0
  		UserMailer.delay.daily_mail(u, actions) 		
  	end
  end
  
  puts "done."
end

task :top_authors => :environment do
  puts "start generating..."
  	array=[]
    all_authors = Author.all 
    ranked_authors = all_authors.sort! { |a,b| b.users.count <=> a.users.count }.first(250)
    ranked_authors.each do |a|
    	array += Array.wrap(a.id)
    end

	ranked_authors_string= array.join(",")
    list=List.new
    list.top_authors=ranked_authors_string
    list.save


  
  puts "done."
end