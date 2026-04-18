class CreatePointAdjustments < ActiveRecord::Migration[7.1]
  def change
    create_table :point_adjustments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.integer :amount, null: false
      t.string :reason

      t.timestamps
    end
  end
end
