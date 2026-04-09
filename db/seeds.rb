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
RecipeMealPlan.destroy_all
MealPlan.destroy_all
Task.destroy_all
TaskTemplate.destroy_all
Reward.destroy_all
RewardTemplate.destroy_all
User.destroy_all
Family.destroy_all
Recipe.destroy_all


ActiveRecord::Base.connection.reset_pk_sequence!('families')
ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('tasks')
ActiveRecord::Base.connection.reset_pk_sequence!('recipes')
ActiveRecord::Base.connection.reset_pk_sequence!('rewards')
ActiveRecord::Base.connection.reset_pk_sequence!('reward_templates')
ActiveRecord::Base.connection.reset_pk_sequence!('meal_plans')

puts "Creating Star Wars family..."
family_1 = Family.create!(
  name: "Star Wars"
)

puts "Creating Star Wars family members..."
user_1 = User.create!(
  email: "famble@test.com",
  password: "123456",
  role: "parent",
  name: "Anakin",
  birthdate: "1981-04-09".to_date,
  family: family_1
)

user_2 = User.create!(
  email: "leia@test.com",
  password: "only_hope",
  role: "child",
  name: "Leia",
  birthdate: "2005-04-25".to_date,
  family: family_1
)

user_3 = User.create!(
  email: "luke@test.com",
  password: "light_saber",
  role: "child",
  name: "Luke",
  birthdate: "2005-04-25".to_date,
  family: family_1
)


user_4 = User.create!(
  email: "amidala@test.com",
  password: "naboo_987",
  role: "parent",
  name: "Padme",
  birthdate: "1981-07-09".to_date,
  family: family_1
)

puts "Creating Lion King family..."
family_2 = Family.create!(
  name: "Lion King"
)

puts "Creating Lion King family members..."
User.create!(
  email: "sarabi@test.com",
  password: "mufasa",
  role: "parent",
  name: "Sarabi",
  birthdate: "1994-12-31".to_date,
  family: family_2
)

User.create!(
  email: "simba@test.com",
  password: "hakuna_matata",
  role: "child",
  name: "Simba",
  birthdate: "2019-07-19".to_date,
  family: family_2
)

puts "Creating generic task templates..."

TaskTemplate.create!(
  name: "Taking the trash out",
  description: "Taking the trash out  when it’s full or for pickup",
  task_points: 2,
  montly_frequency: 0
)

TaskTemplate.create!(
  name: "Unloading the dishwasher",
  description: "",
  task_points: 1,
  montly_frequency: 2
)

TaskTemplate.create!(
  name: "Sweeping and mopping floor",
  description: "Sweeping and mopping the kitchen floor",
  task_points: 3,
  montly_frequency: 0
)

TaskTemplate.create!(
  name: "Bedroom cleaning",
  description: "Put toys and books in their designated spots, put dirty clothes in a hamper.",
  task_points: 1,
  montly_frequency: 0
)

TaskTemplate.create!(
  name: "Cleaning dishes",
  description: "After dinner, clean the dishes or put them in the dishwasher.",
  task_points: 1,
  montly_frequency: 7
)


TaskTemplate.create!(
  name: "Setting table",
  description: "At 7 pm, set the table for dinner",
  task_points: 1,
  montly_frequency: 7
)

TaskTemplate.create!(
  name: "Time out and homework",
  description: "After school and snack, go in the garden for at least 30 minutes. After that do your homeworks. Go to a parent when finished.",
  task_points: 1,
  montly_frequency: 7
)

TaskTemplate.create!(
  name: "Pets care",
  description: "Each day, feed the pet morning and evening. Let them go to the garden after school. Don't forget to pet them.",
  task_points: 1,
  montly_frequency: 7
)

puts "Creating Star wars family first task template..."

template_2 = TaskTemplate.create!(
  name: "Oil R2-D2",
  description: "Each month, put some oil inside R2-D2 collar",
  task_points: 1,
  days: ["monday"],
  montly_frequency: 12,
  family: family_1
)

puts "Creating tasks..."

Task.create!(
  name: "Dinner meal preparation",
  description: "Details in meal plans",
  status: false,
  start_date: (Date.today+1),
  end_date: (Date.today + 365),
  task_points: 2,
  days: ["monday", "wednesday", "saturday"],
  montly_frequency: 12,
  user: user_1
)

Task.create!(
  name: "Washing one's bedroom",
  status: false,
  start_date: Date.today,
  end_date: Date.today,
  task_points: 8,
  days: ["sunday"],
  montly_frequency: 12,
  user: user_2
)

Task.create!(
  name: "Starting Sith revolution",
  status: true,
  start_date: Date.today,
  end_date: Date.today,
  task_points: 4,
  montly_frequency: 0,
  user: user_1
)

Task.create!(
  name: "Oil R2-D2",
  description: "Each month, put some oil inside R2-D2 collar",
  task_points: 1,
  days: ["monday"],
  montly_frequency: 12,
  status: false,
  start_date: Date.today,
  end_date: Date.today + 120,
  user: user_3,
  task_template: template_2
)


Task.create!(
  name: "Luke's doctor appointment",
  status: false,
  start_date: Date.today+5,
  end_date: Date.today+5,
  task_points: 4,
  montly_frequency: 0,
  user: user_4
)

puts "Creating recipes..."

recipe_1 = Recipe.create!(
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

recipe_2 = Recipe.create!(
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

recipe_3 = Recipe.create!(
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

recipe_4 = Recipe.create!(
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

recipe_5 = Recipe.create!(
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

puts "Creating reward templates..."

RewardTemplate.create!(
  name: "Movie night",
  description: "Pick a movie for the whole family to watch together",
  reward_points: 10
)

RewardTemplate.create!(
  name: "Extra screen time",
  description: "30 minutes of bonus screen time",
  reward_points: 5
)

RewardTemplate.create!(
  name: "Ice cream outing",
  description: "A trip to the ice cream shop",
  reward_points: 15
)

RewardTemplate.create!(
  name: "New book",
  description: "Choose a new book to read",
  reward_points: 20
)

RewardTemplate.create!(
  name: "Sleep in Saturday",
  description: "No chores until noon on Saturday",
  reward_points: 8
)

RewardTemplate.create!(
  name: "Pick dinner",
  description: "Choose what the family eats for dinner",
  reward_points: 7
)

puts "Creating rewards..."

Reward.create!(
  name: "Movie night",
  description: "Pick a movie for the whole family to watch together",
  reward_points: 10,
  redeemed: false,
  user: user_2
)

Reward.create!(
  name: "Extra screen time",
  description: "30 minutes of bonus screen time",
  reward_points: 5,
  redeemed: false,
  user: user_2
)

Reward.create!(
  name: "Ice cream outing",
  description: "A trip to the ice cream shop",
  reward_points: 15,
  redeemed: false,
  user: user_2
)

Reward.create!(
  name: "New book",
  description: "Choose a new book to read",
  reward_points: 20,
  redeemed: false,
  user: user_1
)

Reward.create!(
  name: "Sleep in Saturday",
  description: "No chores until noon on Saturday",
  reward_points: 8,
  redeemed: false,
  user: user_1
)

puts "Creating Meal plans..."

meal_plan_today = MealPlan.find_or_create_by!(
  day: Date.today,
  family: family_1
)

meal_plan_tomorrow = MealPlan.find_or_create_by!(
  day: Date.today + 1,
  family: family_1
)


puts "Creating RecipeMealplans..."

  RecipeMealPlan.create!(
  meal_plan: meal_plan_today,
  recipe: recipe_1,
  meal_type: "Breakfast"
)

  RecipeMealPlan.create!(
    meal_plan: meal_plan_today,
    recipe: recipe_5,
    meal_type: "Lunch"
  )

  RecipeMealPlan.create!(
    meal_plan: meal_plan_today,
    recipe: recipe_4,
    meal_type: "Dinner"
  )

  RecipeMealPlan.create!(
    meal_plan: meal_plan_tomorrow,
    recipe: recipe_3,
    meal_type: "Lunch"
  )

  RecipeMealPlan.create!(
    meal_plan: meal_plan_tomorrow,
    recipe: recipe_2,
    meal_type: "Dinner"
  )

  puts "Creating chats..."

chat_1 = Chat.create!(
  user: user_1,
  title: "High protein recipe",
)

chat_2 = Chat.create!(
  user: user_1,
  title: "Funny Breakfast",
)

puts "Creating chat's messages..."

Message.create!(
  chat: chat_1,
  role: "user",
  content: "Help me find a high-protein recipe"
)

Message.create!(
  chat: chat_1,
  role: "assistant",
  content: '
    {
      "name": "High-Protein Greek Yogurt Chicken Salad",
      "ingredients": [
        {"ingredient": "cooked chicken breast, shredded", "quantity": "150 g"},
        {"ingredient": "plain nonfat Greek yogurt", "quantity": "120 g"},
        {"ingredient": "celery, finely chopped", "quantity": "50 g"},
        {"ingredient": "red onion, finely chopped", "quantity": "20 g"},
        {"ingredient": "lemon juice", "quantity": "1 tablespoon"},
        {"ingredient": "Dijon mustard", "quantity": "1 teaspoon"},
        {"ingredient": "salt", "quantity": "1/4 teaspoon"},
        {"ingredient": "black pepper", "quantity": "1/4 teaspoon"},
        {"ingredient": "fresh parsley, chopped", "quantity": "1 tablespoon"}
      ],
      "method": [
        "Place the shredded cooked chicken breast in a large bowl.",
        "Add the Greek yogurt, lemon juice, and Dijon mustard.",
        "Mix in the chopped celery, red onion, and parsley.",
        "Season with salt and black pepper.",
        "Stir everything together until well combined and creamy.",
        "Serve immediately or refrigerate for 30 minutes to enhance the flavor."
      ],
      "keywords": ["high protein", "healthy", "low carb", "quick meal"],
      "calories": 310,
      "allergens": ["dairy", "mustard"]
    }
  '
)

Message.create!(
  chat: chat_2,
  role: "user",
  content: "help me find a funny breakfast "
)

Message.create!(
  chat: chat_2,
  role: "assistant",
  content: '
    {
      "name": "Pancake Smiley Faces",
      "ingredients": [
        {"ingredient": "pancake mix, shredded", "quantity": "200 g"},
        {"ingredient": "water or milk", "quantity": "150 ml"},
        {"ingredient": "chocolate chips", "quantity": "50 g"},
        {"ingredient": "banana slices", "quantity": "1 banana"},
        {"ingredient": "strawberries ", "quantity": "3 pieces"}
      ],
      "method": [
        "Prepare the pancake batter according to the instructions on the mix using water or milk.",
        "Heat a non-stick pan on medium heat and pour small amounts of batter to create pancakes.",
        "Cook each pancake for 2-3 minutes per side until golden brown.",
        "Use chocolate chips to create the eyes and mouth on each pancake.",
        "Add banana slices and strawberries as additional decorations for the funny face.",
        "Serve and enjoy your funny pancake breakfast."
      ],
      "keywords": ["fun breakfast", "pancakes", "decorative"],
      "calories": 400,
      "allergens": ["gluten", "dairy"]
    }
  '
)

Message.create!(
  chat: chat_2,
  role: "user",
  content: "funny breakfast but not pancakes"
)

Message.create!(
  chat: chat_2,
  role: "assistant",
  content: '
    {
      "name": "Egg & Toast Funny Animal Faces",
      "ingredients": [
        {"ingredient": "sliced bread", "quantity": "2 slices"},
        {"ingredient": "hard-boiled eggs", "quantity": "2 eggs"},
        {"ingredient": "cherry tomatoes", "quantity": "4"},
        {"ingredient": "cucumber", "quantity": "1 small, sliced"},
        {"ingredient": "black olives", "quantity": "4"},
        {"ingredient": "cream cheese", "quantity": "2 tbsp"},
        {"ingredient": "carrot", "quantity": "1 small, sliced into thin sticks"}
      ],
      "method": [
        "Toast the slices of bread until golden brown.",
        "Spread cream cheese evenly over each slice of toast.",
        "Cut the hard-boiled eggs into slices and place them on the toast as the base for the face.",
        "Use cucumber slices for eyes, cherry tomatoes for cheeks, and black olives for pupils.",
        "Arrange carrot sticks to make whiskers or ears to complete the animal faces.",
        "Serve immediately and enjoy the playful presentation!"
      ],
      "keywords": ["fun breakfast", "animal faces", "kids meal"],
      "calories": 320,
      "allergens": ["gluten", "dairy", "eggs"]
    }
  '
)


puts "Finished! Created #{Task.count} tasks, #{Recipe.count} recipes and #{Reward.count} rewards, #{MealPlan.count} meal plans, #{RecipeMealPlan.count} recipemealplans, #{Chat.count} chat(s) and #{Message.count} messages!"
