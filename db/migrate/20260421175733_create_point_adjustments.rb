class CreatePointAdjustments < ActiveRecord::Migration[7.1]
  def change
    create_table :point_adjustments do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.string :kind
      t.string :reason

      t.timestamps
    end
  end
end
