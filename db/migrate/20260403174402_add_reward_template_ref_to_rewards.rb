class AddRewardTemplateRefToRewards < ActiveRecord::Migration[7.1]
  def change
    add_reference :rewards, :reward_template, null: true, foreign_key: true
  end
end
