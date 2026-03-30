class RecipesController < ApplicationController

  def index
    @recipes = Recipe.all
  end

  def create
    # TODO change it to save recipes with chatbot?
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      redirect_to recipes_path, notice: "Recipe created successfully!"
    else
      render :new
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :ingredients, :description, :keywords, :calories, :allergens)
  end
end
