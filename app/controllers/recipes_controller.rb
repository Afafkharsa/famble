class RecipesController < ApplicationController

  def index
    if params[:query].present?
      query = "%#{params[:query].downcase}%"
      @recipes = Recipe.where(
        "LOWER(name) LIKE :q OR LOWER(ingredients) LIKE :q OR LOWER(description) LIKE :q OR LOWER(keywords) LIKE :q",
        q: query
      )
    else
      @recipes = Recipe.all
    end
  end

  def new
    @recipe = Recipe.new
  end

  def create
    # TODO change it to save recipes with chatbot?
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      redirect_to recipes_path, notice: "Recipe created successfully!"
    else
      render :new, status: :unprocessable_entity
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
