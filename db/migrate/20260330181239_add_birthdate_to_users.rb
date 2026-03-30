class AddBirthdateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :birthdate, :date
  end
end
