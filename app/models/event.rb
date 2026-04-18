class Event < ApplicationRecord
  belongs_to :user # creator
  has_one :family, through: :user

  has_many :event_participations, dependent: :destroy
  has_many :participants, through: :event_participations, source: :user

  validates :title, presence: true
  validates :start_time, presence: true
end
