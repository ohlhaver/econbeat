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