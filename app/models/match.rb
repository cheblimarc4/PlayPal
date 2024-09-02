class Match < ApplicationRecord
  belongs_to :user
  belongs_to :sport
  has_many :UserMatches, dependent: :destroy
  has_many :users, through: :UserMatches
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  include PgSearch::Model
  pg_search_scope :search,
  against: [ :match_date, :level, :match_time ],
  associated_against: {
    sport: [:name]
  },
  using: {
    tsearch: { prefix: true }
  }

  ICONS = {
    "volleyball" => "fa-solid fa-volleyball",
    "football" => "fa-regular fa-futbol",
    "basketball" => "fa-solid fa-basketball",
    "padel" => "fa-solid fa-table-tennis-paddle-ball",
    "squash" => "fa-solid fa-table-tennis-paddle-ball"
  }.freeze

  PHOTOS = {
    "volleyball" => "https://plus.unsplash.com/premium_photo-1686836995218-555706df014c?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "football" => "https://images.unsplash.com/photo-1624880357913-a8539238245b?q=80&w=3000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "basketball" => "https://plus.unsplash.com/premium_photo-1668032525950-59d3abdce51f?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "padel" => "https://plus.unsplash.com/premium_photo-1709075562029-b64d3ddeb79a?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "squash" => "https://plus.unsplash.com/premium_photo-1707152794942-03740f9f46b9?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
}.freeze

  def add_results(team_a_score, team_b_score)
    # return false unless self.user == current_user
    self.team_a_score = team_a_score
    self.team_b_score = team_b_score
    self.winning_team = team_a_score > team_b_score ? 1 : 2
    self.save
    if self.game_type == "Competitive"
      update_user_ratings
    end
  end

  def update_user_ratings
    winning_users = self.UserMatches.where(team: self.winning_team)
    losing_users = self.UserMatches.where.not(team: self.winning_team)

    winning_users.each do |winner|
      user = User.find(winner.user_id)
      user.increment!(:rating, 0.8)
    end
    losing_users.each do |loser|
      user = User.find(loser.user_id)
      user.decrement!(:rating, 0.8)
    end
  end


  def show_banner
    PHOTOS.fetch(sport.name)
  end

  def sport_icon
    ICONS.fetch(sport.name, "fa-solid fa-question")
  end

end
