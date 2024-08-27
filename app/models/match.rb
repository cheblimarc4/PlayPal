class Match < ApplicationRecord
  belongs_to :user
  belongs_to :sport
  has_many :UserMatches
  has_many :users, through: :UserMatches
end
