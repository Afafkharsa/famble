class MealPlan < ApplicationRecord
  belongs_to :family
  has_many :recipe_meal_plans, dependent: :destroy
  has_many :recipes, through: :recipe_meal_plans
  accepts_nested_attributes_for :recipe_meal_plans, allow_destroy: true

  validates :meal, presence: true
  validates :day, presence: true
end
