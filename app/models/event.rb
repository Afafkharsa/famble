class Event < ApplicationRecord
  belongs_to :user
  has_one :family, through: :user

  validates :title, presence: true
  validates :start_time, presence: true
end
