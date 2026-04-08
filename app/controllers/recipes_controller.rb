class RecipesController < ApplicationController

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

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe was deleted!", status: :see_other
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :ingredients, :description, :keywords, :calories, :allergens)
  end
end
