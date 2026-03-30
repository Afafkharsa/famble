class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.string :name
      t.text :description
      t.integer :reward_points
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
