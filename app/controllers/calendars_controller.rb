class CalendarsController < ApplicationController
  def index
    @events = policy_scope(Event)
    @tasks = policy_scope(Task)
    @meal_plans = policy_scope(MealPlan)
    @combined_items = @events + @tasks + @meal_plans
  end

  def day_detail
    #@date = params[:date].present? ? Date.parse(params:[:date]) : Date.today
    if params[:date].present?
      @date = params[:date].to_date
    else
      @date = Date.today
    end
    @events = Event.where(start_time: @date.all_day)
    @tasks = Task.where(end_date: @date.all_day)
    @meal_plans = MealPlan.where(day: @date).includes(recipe_meal_plans: :recipe)
    render layout: false
  end

  def show
    @date = Date.parse(params:[:date])

    @items = policy_scope(Event).where(start_time: @date.all_day) +
             policy_scope(Task).where(end_date: @date.all_day) +
             policy_scope(MealPlan).where(day: @date.all_day)
    render layout: false
  end

  def new
  end

  def edit
  end

  def destroy
  end
end
