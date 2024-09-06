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


names = ["Margarida", "João", "David", "Ines", "Rita", "Henrique", "Marta Rosa", "Mariana", "Francisco", "Francisco Teacher", "Gonçalo","Marc", "Teresa", "Guillaume", "Lucelia", "Zainan", "Afonso"]
photo = ["https://ca.slack-edge.com/T02NE0241-USN1K7YLE-ce4c21c34c01-512","https://ca.slack-edge.com/T02NE0241-U8A945YB0-5a961e901c6a-512", "https://ca.slack-edge.com/T02NE0241-U01439WBLBA-03c468fd4087-512", "https://ca.slack-edge.com/T02NE0241-U028GBBK6MR-a12d5f81d0ad-512", "https://ca.slack-edge.com/T02NE0241-UHU7RTVL4-d16238381bd6-512", "https://ca.slack-edge.com/T02NE0241-U028GBY5DFC-ed25edc41a04-512", "https://ca.slack-edge.com/T02NE0241-U078RSC24G1-3fe4d728e522-512","https://ca.slack-edge.com/T02NE0241-U8RK8CLFN-bcfaccdf0495-512","https://ca.slack-edge.com/T02NE0241-U02TRJ4F37B-826d1eb9bef6-512","https://ca.slack-edge.com/T02NE0241-U058ZAEHAK0-3c9186eb7b4f-512","https://ca.slack-edge.com/T02NE0241-U07B52UHMJS-d9cfa1feec0f-512","https://ca.slack-edge.com/T02NE0241-U07C0U8Q4D6-58a0dcba64fc-512","https://ca.slack-edge.com/T02NE0241-U07AXMZKK9D-20d05d5991f2-512","https://ca.slack-edge.com/T02NE0241-U07BAF5P750-c50eceafbba1-512","https://ca.slack-edge.com/T02NE0241-U075Z0K9KD4-b2b4659d1075-512","https://ca.slack-edge.com/T02NE0241-U07BZJ2RNHE-c61614479c7f-72","https://ca.slack-edge.com/T02NE0241-U07B9TSJG1Z-83002c8afa7e-512"]
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

20.times do
Match.create(user:User.all.sample, match_time: time.sample, need: 0, location: locations.sample, sport:Sport.all.sample, level: levels.sample, match_date:Faker::Date.between(from: '2024-09-23', to: '2024-09-30') , game_type:types.sample)
end




puts "Making random usermatches"

@matches = Match.all
@matches.each do |match|
  UserMatch.create(user: match.user, match: match, status: "accepted", team: (Random.rand() > 0.5 ? "teamA" : "teamB" ))
  names.each do |name|
    if name != match.user.first_name
      puts "Creating #{name} User Match"
      user = User.where(first_name: name).first
      UserMatch.create(user: user, match: match)
    end
  end
end


puts "Creating David's football match"

matches = []
UserMatch.where(user: User.find_by(first_name: "David")).each do |usermatch|
  next if usermatch.match.sport.name == "squash"
  usermatch.update!(status: "accepted")
  unless usermatch.match.user == usermatch.user
    usermatch.update!(team: (Random.rand() > 0.5 ? "teamA" : "teamB"))
  end
  puts "#{usermatch}'s match found"
  total_players = usermatch.match.sport.number_of_players
  puts "#{total_players} players needed"
  players_in_match = usermatch.match.need + usermatch.match.UserMatches.where(team: "teamA").count + usermatch.match.UserMatches.where(team: "teamB").count
  puts "#{players_in_match} for #{usermatch.match.sport.name}"
  players_needed = total_players - players_in_match
  puts "#{players_needed} players needed"
  players_needed.times do
    usermatch = usermatch.match.UserMatches.where(status: "pending").first

    players_in_team_a = usermatch.match.UserMatches.teamA
    players_in_team_b = usermatch.match.UserMatches.teamB
    players_in_each_team = usermatch.match.sport.number_of_players / 2
    if players_in_team_a.count < players_in_each_team
      usermatch.update!(status: "accepted")
      usermatch.update!(team: "teamA")
    elsif players_in_team_b.count < players_in_each_team
      usermatch.update!(status: "accepted")
      usermatch.update!(team: "teamB")
    end
  end
  matches << usermatch.match
  if matches.length == 4
    break
  end
end
puts "Setting matches as ready and rating"
matches.each do |match|
  match.update!(ready: true)
  a_score = rand(0..50)
  b_score = rand(0..50)
  while a_score == b_score
    b_score = rand(0..50)
  end
  puts a_score
  puts b_score
  winner = (a_score > b_score ? 1 : 2)
  match.update!(team_a_score: a_score, team_b_score: b_score, winning_team: winner)
end


puts "Creating Henrique's football match"

match = Match.create(user: User.where(email: "henrique@gmail.com").first, match_time: "08:00", need: 0 , sport: Sport.where(name: "football").first, location: "Alvalade, Lisbon, Portugal", level: "Beginner", match_date: "2021-09-23", game_type: "Competitive")
UserMatch.create(user: match.user, match: match, status: "accepted", team: (Random.rand() > 0.5 ? "teamA" : "teamB" ))
names.each do |name|
  if name != "Henrique" && name != "David"
    puts "Creating #{name} User Match"
    user = User.where(first_name: name).first
    UserMatch.create(user: user, match: match)
  end
end
