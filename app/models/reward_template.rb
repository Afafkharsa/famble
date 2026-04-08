class RewardTemplate < ApplicationRecord
  has_many :rewards
  has_one_attached :photo
  validates :name, presence: true
end
