class Match < ApplicationRecord
  belongs_to :user
  belongs_to :sport
  has_many :UserMatches
  has_many :users, through: :UserMatches

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

  def sport_icon
    ICONS.fetch(sport.name, "fa-solid fa-question")
  end

end
