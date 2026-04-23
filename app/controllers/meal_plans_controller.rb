class MealPlansController < ApplicationController
  def index
    @family = current_user.family
    @meal_plans = policy_scope(MealPlan)
    @today_plan = @meal_plans.find_by(day:Date.today)
    @weekly_plans = @meal_plans.where(day: (Date.today + 1)..(Date.today + 7)).order(:day)
  end

  def show
    @meal_plan = MealPlan.find(params[:id])
    authorize @meal_plan
  end

  def new
    @meal_plan = MealPlan.new(day: params[:day])
    authorize @meal_plan
    rmp = @meal_plan.recipe_meal_plans.build
    rmp.meal_type = params[:meal_types] if params[:meal_types]
  end

  def create
    @meal_plan = MealPlan.find_or_create_by(day:params[:meal_plan][:day], family_id:current_user.family_id)

    authorize @meal_plan

    if @meal_plan.update(meal_plan_params)
      redirect_to meal_plans_path, notice: "Meal plan created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @meal_plan = MealPlan.find(params[:id])
    authorize @meal_plan
  end

  def update
    @meal_plan = MealPlan.find(params[:id])
    authorize @meal_plan
    if @meal_plan.update(meal_plan_params)
      redirect_to meal_plans_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meal_plan = MealPlan.find(params[:id])
    authorize @meal_plan
    @meal_plan.destroy
    redirect_to meal_plans_path, status: :see_other
  end

  private

  def meal_plan_params
    params.require(:meal_plan).permit(:day, :family_id, recipe_meal_plans_attributes: [:id, :meal_type, :recipe_id, :_destroy])
  end
end
