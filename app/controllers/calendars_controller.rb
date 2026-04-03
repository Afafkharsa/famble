class CalendarsController < ApplicationController
  def index
    @events = Event.all
    @tasks = Task.all
    @meal_plans = MealPlan.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def destroy
  end
end
