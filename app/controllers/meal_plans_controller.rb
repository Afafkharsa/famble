class MealPlansController < ApplicationController
  def index

    @family =current_user.family
    @meal_plans = @family.meal_plans.includes(recipe_meal_plans: :recipe)
    # @meal_plans = current_user.meal_plans
    # @today_meals = current_user.meal_plans.where(date: Date.today).order(:meal_type)
    # @weekly_meals = current_user.meal_plans.where(date: Date.today + 1..Date.today + 6.days).order(date: :asc)
  end

  def show
    @meal_plan = MealPlan.find(params[:id])
    @recipes = @meal_plan.recipes
    @day_meals = current_user.meal_plans.where(date: @meal_plan.date).order(:meal_type)
  end

  def new
    @meal_plan = MealPlan.new
    @meal_plan.recipe_meal_plans.build
  end

  def create
    @meal_plan = current_user.meal_plans.new(meal_plan_params)
    if @meal_plan.save
      redirect_to meal_plans_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @meal_plan = MealPlan.find(params[:id])
  end

  def update
    @meal_plan = MealPlan.find(params[:id])
    if @meal_plan.update(meal_plan_params)
      redirect_to meal_plans_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meal_plan = MealPlan.find(params[:id])
    @meal_plan.destroy
    redirect_to meal_plans_path
  end

  private

  def meal_plan_params
    params.require(:meal_plan).permit(:day, :family_id, recipe_meal_plans_attributes: [:id, :meal_type, :recipe_id, :_destroy])
  end
end
