class Event < ApplicationRecord
  belongs_to :user, dependent: :destroy
  validates :title, presence: true
  validates :start_time, presence: true
end
