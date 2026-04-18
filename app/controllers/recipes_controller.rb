class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @recipes = Recipe.all

    if params[:query].present?
      sql = <<~SQL
        name ILIKE :query
        OR ingredients ILIKE :query
        OR description ILIKE :query
        OR keywords ILIKE :query
      SQL

      @recipes = @recipes.where(sql, query: "%#{params[:query]}%")
    end
  end

  def show
  end

  def new
    @recipe = Recipe.new
  end

  def create
    if params[:save_to_meal_plan]
      @meal_plan = current_user.meal_plans.find_or_create_by(
        date: params[:recipe][:meal_plan_date],
        meal_type: params[:recipe][:meal_plan_type]
      ) do |mp|
        mp.meal = params[:recipe][:name]
      end
      @recipe = @meal_plan.recipes.new(recipe_params)
    else
      @recipe = Recipe.new(recipe_params)
    end

    if @recipe.save
      ImageGeneratorService.generate_and_attach(@recipe)

      if @meal_plan
        redirect_to meal_plans_path, notice: "Recipe saved to meal plan!"
      else
        redirect_to recipes_path, notice: "Recipe saved!"
      end
    else
      redirect_back fallback_location: chats_path, alert: @recipe.errors.full_messages.join(", ")
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe was deleted!", status: :see_other
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :ingredients, :description, :keywords, :calories, :allergens, :photo)
  end
end
