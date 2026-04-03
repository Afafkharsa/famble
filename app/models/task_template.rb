class TaskTemplate < ApplicationRecord
  has_many :tasks
  belongs_to :family, optional: true
end
