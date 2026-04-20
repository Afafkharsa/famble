require "open-uri"

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
    photo_url = params.dig(:recipe, :photo)
    @recipe = Recipe.new(recipe_params.except(:photo))

    if params[:save_to_meal_plan].present?
      @meal_plan = current_user.family.meal_plans.find_or_create_by(
        day: params[:recipe][:meal_plan_date]
      ) do |mp|
        mp.meal = params[:recipe][:name]
      end
    end

    if @recipe.save
      attach_recipe_photo(@recipe, photo_url)

      if @meal_plan
        @meal_plan.recipe_meal_plans.create!(
          recipe: @recipe,
          meal_type: params[:recipe][:meal_plan_type]
        )
        redirect_to meal_plan_path(@meal_plan), notice: "Recipe saved to meal plan!"
      else
        redirect_to recipes_path, notice: "Recipe saved!"
      end
    else
      redirect_back fallback_location: chats_path, alert: @recipe.errors.full_messages.join(", ")
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe updated successfully."
    else
      render :edit, status: :unprocessable_entity
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
    params.require(:recipe).permit(:name, :ingredients, :description, :keywords, :calories, :allergens, :photo)
  end

  def attach_recipe_photo(recipe, url)
    if url.is_a?(String) && url.strip.present?
      begin
        file = URI.parse(url.strip).open
        recipe.photo.attach(
          io: file,
          filename: "recipe_#{recipe.id}.jpg",
          content_type: file.content_type || "image/jpeg"
        )
      rescue => e
        Rails.logger.warn "Could not attach photo from URL: #{e.message}"
        ImageGeneratorService.generate_and_attach(recipe)
      end
    else
      ImageGeneratorService.generate_and_attach(recipe)
    end
  end
end
