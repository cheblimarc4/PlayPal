class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :matches, through: :UserMatches
  has_many :UserMatches

  validates :first_name , presence: true
  validates :email, uniqueness: true
end
