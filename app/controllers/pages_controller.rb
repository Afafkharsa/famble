class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    if current_user&.role
    @family = current_user.family
    @members = @family.users.order(:birthdate)
    today = Date.today

    @tasks_today       = @family.tasks.where("start_date <= ? AND end_date >= ?", today, today)
    @tasks_today_done  = @tasks_today.where(validation: true).size

    @todays_meal_plan  = @family.meal_plans.find_by(day: today)
    @meals_today_count = @todays_meal_plan ? @todays_meal_plan.recipes.size : 0

    week = Time.current.beginning_of_week..Time.current.end_of_week
    @week_events = @family.events.where(start_time: week).order(:start_time)
    @next_event  = @week_events.where("start_time >= ?", Time.current).first

    @family_points = @members.sum(&:earned_points)
    @todays_recipe_meal_plans = @todays_meal_plan ? @todays_meal_plan.recipe_meal_plans.includes(:recipe) : []
    @leaderboard = @members
      .map { |m| { member: m, earned: m.earned_points, to_spend: m.available_points } }
      .sort_by { |row| -row[:earned] }
    @top_points = @leaderboard.first&.dig(:earned).to_i
    end
  end
end
