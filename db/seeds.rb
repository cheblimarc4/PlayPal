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


names = ["Margarida", "João", "David", "Ines", "Rita", "Henrique", "Marta Rosa", "Mariana", "Franciso P1", "Francisco P2", "Gonçalo"]
photo = ["https://ca.slack-edge.com/T02NE0241-USN1K7YLE-ce4c21c34c01-512","https://ca.slack-edge.com/T02NE0241-U8A945YB0-5a961e901c6a-512", "https://ca.slack-edge.com/T02NE0241-U01439WBLBA-03c468fd4087-512", "https://ca.slack-edge.com/T02NE0241-U028GBBK6MR-a12d5f81d0ad-512", "https://ca.slack-edge.com/T02NE0241-UHU7RTVL4-d16238381bd6-512", "https://ca.slack-edge.com/T02NE0241-U028GBY5DFC-ed25edc41a04-512", "https://ca.slack-edge.com/T02NE0241-U078RSC24G1-3fe4d728e522-512","https://ca.slack-edge.com/T02NE0241-U8RK8CLFN-bcfaccdf0495-512","https://ca.slack-edge.com/T02NE0241-U02TRJ4F37B-826d1eb9bef6-512","https://ca.slack-edge.com/T02NE0241-U058ZAEHAK0-3c9186eb7b4f-512","https://ca.slack-edge.com/T02NE0241-U07B52UHMJS-d9cfa1feec0f-512"]
ages = [25, 30, 35, 40, 45, 50, 55, 60, 65, 70]
emails = names.map { |name| name.downcase.delete(" ") + "@gmail.com" }
ratings = names.length.times.map { format('%.1f', (rand(10..50) / 10.0)) }
locations = ["Lisbon", "Porto", "Faro", "Coimbra", "Braga", "Aveiro", "Leiria", "Viseu", "Viana do Castelo", "Setúbal"]
match_date = ["2021-09-23", "2021-09-24", "2021-09-25", "2021-09-26", "2021-09-27", "2021-09-28", "2021-09-29", "2021-09-30", "2021-10-01", "2021-10-02"]


puts "Done!"
sports.each_with_index do |sport, index|
  Sport.create(name: sport, number_of_players: players[index])
end

names.each_with_index do |name, index|
  user = User.create!(first_name: name, last_name: name, email: "#{emails[index]}", password:"123456",rating:  format('%.1f', (rand(10..50) / 10.0)) )
  file = URI.open(photo[index])
  user.photo.attach(io: file, filename: "#{name}.png", content_type: 'image/jpg')
end

5.times do
Match.create(user:User.all.sample, match_time: time.sample, need: 0, sport:Sport.all.sample, location: locations.sample, level: levels.sample, match_date:Faker::Date.between(from: '2024-09-23', to: '2024-09-30') , game_type:types.sample)
end

# @matches = Match.all
# @matches.each do |match|
# users = User.where.not(id: match.user.id)
# username = []
# Random.rand(1..5).times do
#   user = users.where.not(first_name: username).sample
#   user = users.sample
#   username.push(user.first_name)
#   UserMatch.create(user: user, match: match)

# end
# end
