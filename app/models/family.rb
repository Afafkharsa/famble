class Family < ApplicationRecord
  has_many :users
  has_many :tasks, through: :users
  has_many :meal_plans, dependent: :destroy
end
