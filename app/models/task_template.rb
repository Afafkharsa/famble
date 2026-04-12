class TaskTemplate < ApplicationRecord
  has_many :tasks
  belongs_to :family, optional: true

  validates :name, presence: true, length: { minimum: 2 }
  validates :task_points, numericality: { greater_than_or_equal_to: 1 }
end
