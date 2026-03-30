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
Task.destroy_all
User.destroy_all
Recipe.destroy_all

ActiveRecord::Base.connection.reset_pk_sequence!('tasks')
ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('recipes')

puts "Creating users..."
user_1 = User.create!(
  email: "famble@test.com",
  password: "123456",
  role: "parent",
  name: "Anakin",
  birthdate: "1981-04-09".to_date
)

puts "Creating tasks..."

Task.create!(
  name: "Meal preparation",
  description: "Details in meal plans",
  status: false,
  start_date: Date.today,
  end_date: Date.today,
  task_points: 2,
  frequency: 7,
  user: user_1
)


puts "Creating recipes..."

Recipe.create!(
  name: "Spaghetti Bolognese",
  ingredients: <<~INGREDIENTS,
    200g spaghetti
    150g ground beef
    1 onion, diced
    2 cloves garlic, minced
    400g canned tomatoes
    2 tbsp olive oil
    Salt and pepper to taste
  INGREDIENTS
  description: <<~INGREDIENTS,
    200g spaghetti
    150g ground beef
    1 onion, diced
    2 cloves garlic, minced
    400g canned tomatoes
    2 tbsp olive oil
    Salt and pepper to taste
  INGREDIENTS
  keywords: "pasta, italian, meat",
  calories: 450,
  allergens: "gluten"
)

Recipe.create!(
  name: "Chicken Caesar Salad",
  ingredients: <<~INGREDIENTS,
    1 romaine lettuce, chopped
    50g parmesan cheese, grated
    100g croutons
    1 chicken breast, grilled and sliced
    Caesar dressing
  INGREDIENTS
  description: <<~DESCRIPTION,
    Wash and chop romaine lettuce.
    Grill chicken breast and slice thinly.
    In a bowl, mix lettuce, croutons, and parmesan.
    Add chicken on top.
    Drizzle with Caesar dressing.
  DESCRIPTION
  keywords: "salad, chicken, healthy",
  calories: 350,
  allergens: "dairy, gluten"
)

Recipe.create!(
  name: "Vegetable Stir Fry",
  ingredients: <<~INGREDIENTS,
    150g Broccoli
    1 Bell pepper, sliced
    2 Carrots, julienned
    2 tbsp Soy sauce
    2 cloves Garlic, minced
    1 tbsp Sesame oil
    100g Tofu (optional)
  INGREDIENTS
  description: <<~DESCRIPTION,
    Quick and healthy stir-fried vegetables with Asian flavors.
    Serve immediately while hot.
  DESCRIPTION
  keywords: "vegan, quick, asian",
  calories: 250,
  allergens: "soy"
)

Recipe.create!(
  name: "Pancakes",
  ingredients: <<~INGREDIENTS,
    200g Flour
    250ml Milk
    2 Eggs
    50g Sugar
    1 tsp Baking powder
    50g Butter, melted
    Maple syrup for serving
  INGREDIENTS
  description: <<~DESCRIPTION,
    Fluffy breakfast pancakes perfect for weekend mornings.
    Top with syrup or fresh fruits.
  DESCRIPTION
  keywords: "breakfast, sweet, easy",
  calories: 300,
  allergens: "gluten, dairy, eggs"
)

Recipe.create!(
  name: "Grilled Salmon",
  ingredients: <<~INGREDIENTS,
    1 Salmon fillet (200g)
    1 tbsp Olive oil
    1 Lemon, sliced
    2 cloves Garlic, minced
    1 tsp Mixed herbs
    Salt to taste
    Pepper to taste
  INGREDIENTS
  description: <<~DESCRIPTION,
    Fluffy breakfast pancakes perfect for weekend mornings.
    Top with syrup or fresh fruits.
  DESCRIPTION
  keywords: "fish, healthy, dinner",
  calories: 400,
  allergens: "fish"
)

puts "Finished! Created #{Recipe.count} recipes!"
