namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.posts.create!(content: content) }
    end
  end
end