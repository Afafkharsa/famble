class AddPhotoToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :photo, :string
  end
end
