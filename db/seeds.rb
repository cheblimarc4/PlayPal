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
players = [4, 14, 6, 2, 10]
levels = ["Beginner", "Intermediate", "Advanced"]
types = ["Friendly", "Competitive"]

sports.each_with_index do |sport, index|
  Sport.create(name: sport, number_of_players: players[index])
end


10.times do
  User.create(first_name: Faker::Name.name, last_name: Faker::Name.name, email: "#{Faker::Name.name}@gmail.com", password:"123456")
end

10.times do
  Match.create(user:User.all.sample, sport:Sport.all.sample,location:Faker::Address.full_address, level:levels.sample, match_date:Faker::Date.between(from: '2014-09-23', to: '2014-09-25') , game_type:types.sample)
end

10.times do
  UserMatch.create(user:User.all.sample, match:Match.all.sample)
end

puts "Done Seeding"
