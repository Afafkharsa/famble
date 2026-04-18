class CalendarsController < ApplicationController
  def index
    @view = %w[month week day].include?(params[:view]) ? params[:view] : "month"
    @events = policy_scope(Event)
    @tasks = policy_scope(Task)
    @meal_plans = policy_scope(MealPlan)
  end

  def day_detail
    @date = params[:date].present? ? params[:date].to_date : Date.today
    @events = Event.where(start_time: @date.all_day)
    @tasks = Task.where(end_date: @date.all_day)
    @meal_plans = MealPlan.where(day: @date).includes(recipe_meal_plans: :recipe)
    render layout: false
  end
end
