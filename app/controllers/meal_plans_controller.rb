class MealPlansController < ApplicationController
  def index
    @meal_plans = MealPlan.all
  end

  def show
    @meal_plan = MealPlan.find(params[:id])
  end

  def new
    @meal_plan = MealPlan.new
  end

  def create
    @meal_plan = MealPlan.new
  end

  def edit
    @meal_plan = MealPlan.
  end

  def update

  end

  def destroy

  end

  private

  def meal_plans_params
    params.require(:meal_plan).permit(:meal, :photo)
  end
  end

end
