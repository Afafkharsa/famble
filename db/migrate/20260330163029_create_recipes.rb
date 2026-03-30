class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :ingredients
      t.text :description
      t.string :keywords
      t.integer :calories
      t.string :allergens

      t.timestamps
    end
  end
end
