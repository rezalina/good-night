# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
20.times do 
  User.create(name: Faker::Name.name)
end

user_ids = User.pluck(:id)
User.find_each do |user|
  following_ids = (user_ids - [user.id]).sample(10)
  following_ids.each do |id|
    Relationship.create!(follower_id: user.id, followed_id: id)
  end
end

User.find_each do |user|
  5.times do
    clock_in_time = Faker::Time.between_dates(from: Date.today - 30, to: Date.today, period: :night)
    clock_out_time = clock_in_time + rand(2..8).hours

    ClockIn.create!(
      user: user,
      clock_in_time: clock_in_time,
      clock_out_time: clock_out_time
    )
  end
end