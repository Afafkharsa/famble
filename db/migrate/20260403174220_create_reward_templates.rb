class CreateRewardTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :reward_templates do |t|
      t.string :name
      t.text :description
      t.integer :reward_points

      t.timestamps
    end
  end
end
