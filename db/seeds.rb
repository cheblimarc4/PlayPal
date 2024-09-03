# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'
UserMatch.destroy_all
Match.destroy_all
Sport.destroy_all
User.destroy_all

puts "Creating Matches"

sports = ["padel", "football", "basketball", "squash", "volleyball"]

time = [
  "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30",
  "14:00", "14:30", "15:00", "15:30", "16:00", "16:30",
  "17:00", "17:30", "18:00", "18:30", "19:00", "19:30",
  "20:00", "20:30", "21:00", "21:30", "22:00"
]
players = [4, 14, 6, 2, 10]
levels = ["Beginner", "Intermediate", "Advanced"]
types = ["Friendly", "Competitive"]

sports.each_with_index do |sport, index|
  Sport.create(name: sport, number_of_players: players[index])
end


10.times do
  name = Faker::Name.name.delete(" ")
  puts name
  User.create!(first_name: name, last_name: name, email: "#{name}@gmail.com", password:"123456",rating:  format('%.1f', (rand(10..50) / 10.0)) )
end

10.times do
  Match.create(user:User.all.sample, match_time: time.sample, need: Random.rand(5), sport:Sport.all.sample,location:Faker::Address.city, level:levels.sample, match_date:Faker::Date.between(from: '2014-09-23', to: '2014-09-25') , game_type:types.sample)
end


10.times do
  UserMatch.create(user:User.all.sample, match:Match.all.sample)
end
puts "Done!"
