class RecipeMealPlan < ApplicationRecord
  belongs_to :recipe
  belongs_to :meal_plan

  accepts_nested_attributes_for :meal_plan
  after_destroy :destroy_empty_meal_plan


  validates :meal_type, presence: true

  private

  def destroy_empty_meal_plan
    meal_plan.destroy if meal_plan.recipe_meal_plans.count.zero?
  end
end
