class FamilyMealPlansTool < RubyLLM::Tool
  description "Returns upcoming meal plans for the family — what's being cooked for breakfast/lunch/dinner/snack on each day. Use this to answer 'what's for dinner', 'what are we eating this week', or to flag unplanned days so the user can fill them in."

  param :days_ahead, desc: "How many days to look forward starting today (default 7).", required: false, type: "integer"

  def initialize(family:)
    @family = family
  end

  def execute(days_ahead: 7)
    start_date = Date.current
    end_date   = start_date + days_ahead.to_i.days

    plans = @family.meal_plans
                   .where(day: start_date..end_date)
                   .includes(recipe_meal_plans: :recipe)
                   .order(:day)

    plans.map do |plan|
      meals_by_type = plan.recipe_meal_plans.group_by(&:meal_type).transform_values { |rmps| rmps.map { |r| r.recipe.name } }

      {
        day:       plan.day.to_s,
        weekday:   plan.day.strftime("%A"),
        breakfast: meals_by_type["Breakfast"] || [],
        lunch:     meals_by_type["Lunch"]     || [],
        dinner:    meals_by_type["Dinner"]    || [],
        snack:     meals_by_type["Snack"]     || []
      }
    end
  rescue => e
    { error: e.message }
  end
end
