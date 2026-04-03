class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tasks, dependent: :destroy
  belongs_to :family, optional: true
  has_one_attached :photo
  has_many :rewards, dependent: :destroy
  has_many :meal_plans, dependent: :destroy
end
