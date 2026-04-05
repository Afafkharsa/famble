class RecipeMealPlansController < ApplicationController
  belongs_to :meal_plan
  belongs_to :recipe
end
