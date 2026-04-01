class MealPlan < ApplicationRecord
  belongs_to :family
  belongs_to :recipe
end
