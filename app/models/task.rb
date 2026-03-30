class Task < ApplicationRecord
  belongs_to :family_member, class_name: "User"
  belongs_to :task_template, optional: true
end
