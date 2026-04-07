class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :reward_template, optional: true
  has_one_attached :photo
  validates :name, :reward_points, presence: true
  validates :reward_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
