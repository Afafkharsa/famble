class MealPlansController < ApplicationController
  def index
    @family =current_user.family
    @today_plan = @family.meal_plans.find_by(day:Date.today)#includes(recipe_meal_plans: :recipe).where(family:current_user.family).order(:day)
    @weekly_plans = @family.meal_plans.where(day: (Date.today + 1)..(Date.today + 7)).order(:day)
    # @meal_plans = current_user.meal_plans
    # @today_plan = Mealplan.find_by(date: Date.today)
    # @weekly_meals = current_user.meal_plans.where(date: Date.today + 1..Date.today + 6.days).order(date: :asc)
  end

  def show
    @meal_plan = MealPlan.includes(recipe_meal_plans: :recipe).find(params[id])

  end

  def new
    @meal_plan = MealPlan.new
    @meal_plan.recipe_meal_plans.build
  end

  def create
    @meal_plan = MealPlan.new(meal_plan_params)
    @meal_plan.family = current_user.family
    if @meal_plan.save
      redirect_to meal_plans_path, notice: "Meal plan created successfully!"
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
