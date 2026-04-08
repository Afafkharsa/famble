class CalendarsController < ApplicationController
  def index
    @events = Event.all
    @tasks = Task.all
    @meal_plans = MealPlan.all
    @combined_items = @events + @tasks + @meal_plans
  end

  def day_detail
    @date = params[:date] ? Date.parse(params:[:date]) : Date.today
    @events = Event.where(start_time: @date.all_day)
    @tasks = Task.where(end_date: @date.all_day)
    @meal_plans = MealPlan.where(day: @date.all_day)
    render layout: false
  end

  def show
    @date = Date.parse(params:[:date])
    @items = Event.where(start_time: @date.all_day) +
            Task.where(end_date: @date.all_day) +
            MealPlan.where(day: @date.all_day)
    render layout: false
  end

  def new
  end

  def edit
  end

  def destroy
  end
end
