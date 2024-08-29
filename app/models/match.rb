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

end
