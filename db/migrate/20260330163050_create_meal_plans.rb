class CreateMealPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :meal_plans do |t|
      t.date :day
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
