class MealPlan < ApplicationRecord
  belongs_to :family
  belongs_to :recipe
  has_many :recipe_meal_plans, dependent: :destroy
  has_many :recipes, through: :recipe_meal_plans
  accepts_nested_attributes_for :recipe_meal_plans, allow_destroy: true
end
