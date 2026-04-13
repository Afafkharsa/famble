class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_template, optional: true
  has_one :family, through: :user

  validates :name, presence: true, length: { minimum: 2 }
  validates :task_points, numericality: { greater_than_or_equal_to: 1 }
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }
end
