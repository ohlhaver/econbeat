class AuthorsController < ApplicationController
	#before_filter :authorize, only: [:show]
	def show
		@author = Author.find(params[:id])
		@actions = @author.actions
		@actions = Kaminari.paginate_array(@actions).page(params[:page]).per(50)

		if current_user
			@friends = current_user.followed_users
			@subscribed_friends = @friends.find_all{|i| i.subscribed?(@author)}.first(10)
		end
		@all_authors =[]
		@size = @author.users.size
		@author.users.each do |u|
			@all_authors += (u.authors - Array.wrap(@author))
		end

		@author_hash = @all_authors.inject(Hash.new(0)) { |h,n| h[n] += 1; h }
		@author_hash = @author_hash.sort_by {|author, count| -count}
		@ranked_authors = @author_hash.to_a
		@recommended = @ranked_authors.first(3)


	end

	def similar
		@author = Author.find(params[:id])
		
		if current_user
			@friends = current_user.followed_users
			@subscribed_friends = @friends.find_all{|i| i.subscribed?(@author)}
		end
		
		@all_authors =[]
		@size = @author.users.size
		@author.users.each do |u|
			@all_authors += (u.authors - Array.wrap(@author))
		end

		@author_hash = @all_authors.inject(Hash.new(0)) { |h,n| h[n] += 1; h }
		@author_hash = @author_hash.sort_by {|author, count| -count}
		@ranked_authors = @author_hash.to_a
		@recommended = @ranked_authors.first(50)
	end

end
