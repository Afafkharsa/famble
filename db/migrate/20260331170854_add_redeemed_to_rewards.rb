class AddRedeemedToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :redeemed, :boolean
    add_column :rewards, :redeemed_at, :datetime
  end
end
