class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :UserMatches
  has_many :matches, through: :UserMatches
  validates :first_name, presence: true
  validates :email, uniqueness: true
  has_one_attached :photo
end
