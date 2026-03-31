class Task < ApplicationRecord
  belongs_to :user
  belongs_to :family
  belongs_to :task_template, optional: true
end
