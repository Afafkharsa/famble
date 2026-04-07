class AddMealToMealPlans < ActiveRecord::Migration[7.1]
  def change
    add_column :meal_plans, :meal, :string
  end
end
