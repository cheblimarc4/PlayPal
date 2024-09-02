class UserMatch < ApplicationRecord
  belongs_to :user
  belongs_to :match
  enum team: {teamA: 1, teamB:2}
  enum :status, [:pending, :denied, :accepted], default: :pending
end

