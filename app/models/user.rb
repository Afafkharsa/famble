class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :chats, dependent: :destroy
  has_many :tasks, dependent: :destroy
  belongs_to :family, optional: true
  has_one_attached :photo
  has_many :rewards, dependent: :destroy
  has_many :events

  validates :email, uniqueness: true

  def earned_points
    tasks.where(status: true).sum(:task_points)
  end

  def spent_points
    rewards.where(redeemed: true).sum(:reward_points)
  end

  def available_points
    earned_points - spent_points
  end
end
