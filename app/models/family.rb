class Family < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :tasks, through: :users
  has_many :meal_plans, dependent: :destroy
  has_many :task_templates, dependent: :destroy
end
