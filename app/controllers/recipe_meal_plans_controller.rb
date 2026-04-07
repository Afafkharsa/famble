class RecipeMealPlansController < ApplicationController
  before_action :set_recipe_meal_plan, only: [:edit, :update, :destroy]

  def edit
    @recipes = RecipeMealPlan.all
  end

  def update
    if @recipe_meal_plan.update(recipe_meal_plan_params)
      redirect_to meal_plans_path, notice: "Recipe was updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe_meal_plan = RecipeMealPlan.find(params[:id])
    @recipe_meal_plan.destroy
    redirect_to meal_plans_path, notice: :see_other
  end

  private

  def set_recipe_meal_plan
    @recipe_meal_plan = RecipeMealPlan.find(params[:id])
  end

  def recipe_meal_plan_params
    params.require(:recipe_meal_plan).permit(:recipe_id, :meal_plan_id, :meal_type)
  end

end
