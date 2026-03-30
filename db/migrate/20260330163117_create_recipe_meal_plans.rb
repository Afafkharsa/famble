class CreateRecipeMealPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_meal_plans do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :meal_plan, null: false, foreign_key: true
      t.string :meal_type

      t.timestamps
    end
  end
end
