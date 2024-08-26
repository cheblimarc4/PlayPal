class UserMatch < ApplicationRecord
  belongs_to :user
  belongs_to :match
  enum :team, [:teamA, :teamB]
  enum :status, [:pending, :denied, :accepted], default: :pending
end
