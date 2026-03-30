class Recipe < ApplicationRecord
  has_many :recipe_meal_plans
  has_many :meal_plans, through: :recipe_meal_plans

  validates :name, presence: true
  validates :ingredients, presence: true
  validates :description, presence: true

  validates :calories, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
