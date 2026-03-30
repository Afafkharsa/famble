# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."
Tasks.destroy_all
User.destroy_all

puts "Creating users..."
user_1 = User.create!(email: "famble@test.com", password: "123456")

puts "Creating tasks..."

Task.create!(
  name: "Meal preparation",
  description: "Details in meal plans",
  statuts: false,
  start_date: Date.today,
  end_date: Date.today,
  tasks_points: 2,
  frequency: 7,
  family_member_id: user_1
)
