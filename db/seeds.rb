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
Message.destroy_all
Chat.destroy_all
RecipeMealPlan.destroy_all
MealPlan.destroy_all
PointAdjustment.destroy_all
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
ActiveRecord::Base.connection.reset_pk_sequence!('point_adjustments')
ActiveRecord::Base.connection.reset_pk_sequence!('meal_plans')

puts "Creating Star Wars family..."
family_1 = Family.create!(
  name: "Star Wars"
)

puts "Creating Star Wars family members..."
user_1 = User.create!(
  email: "famble@gmail.com",
  password: "123456",
  role: "parent",
  name: "Anakin",
  birthdate: "1981-04-09".to_date,
  family: family_1,
  color: "#F5D2D2"
)
user_1.photo.attach(
  io:  File.open(File.join(Rails.root,'app/assets/images/user_anakin.jpg')),
  filename: 'user_anakin.jpg'
)

user_2 = User.create!(
  email: "leia@gmail.com",
  password: "only_hope",
  role: "child",
  name: "Leia",
  birthdate: "2005-04-25".to_date,
  family: family_1,
  color: "#F8F7BA"
)
user_2.photo.attach(
  io:  File.open(File.join(Rails.root,'app/assets/images/user_leia.jpg')),
  filename: 'user_leia.jpg'
)

user_3 = User.create!(
  email: "luke@gmail.com",
  password: "light_saber",
  role: "child",
  name: "Luke",
  birthdate: "2005-04-25".to_date,
  family: family_1,
  color: "#A3CCDA"
)
user_3.photo.attach(
  io:  File.open(File.join(Rails.root,'app/assets/images/user_luke.jpg')),
  filename: 'user_luke.jpg'
)

user_4 = User.create!(
  email: "amidala@gmail.com",
  password: "naboo_987",
  role: "parent",
  name: "Padme",
  birthdate: "1981-07-09".to_date,
  family: family_1,
  color: "#BDE3C3"
)
user_4.photo.attach(
  io:  File.open(File.join(Rails.root,'app/assets/images/user_amidala.jpg')),
  filename: 'user_amidala.jpg'
)

puts "Creating Lion King family..."
family_2 = Family.create!(
  name: "Lion King"
)

puts "Creating Lion King family members..."
user_5 = User.create!(
  email: "sarabi@gmail.com",
  password: "mufasa",
  role: "parent",
  name: "Sarabi",
  birthdate: "1994-12-31".to_date,
  family: family_2,
  color: "#F5D2D2"
)

user_6 = User.create!(
  email: "simba@gmail.com",
  password: "hakuna_matata",
  role: "child",
  name: "Simba",
  birthdate: "2019-07-19".to_date,
  family: family_2,
  color: "#F8F7BA"
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

template_1 = TaskTemplate.create!(
  name: "Time out and homework",
  description: "After school and snack, go in the garden for at least 30 minutes. After that do your homeworks. Go to a parent when finished.",
  task_points: 1,
  montly_frequency: 7
)

template_2 = TaskTemplate.create!(
  name: "Setting table",
  description: "At 7 pm, set the table for dinner",
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

template_3 = TaskTemplate.create!(
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
  validation: true,
  start_date: Date.today,
  end_date: Date.today,
  task_points: 4,
  montly_frequency: 0,
  user: user_1
)

Task.create!(
  name: "Time out and homework",
  description: "After school and snack, go in the garden for at least 30 minutes. After that do your homeworks. Go to a parent when finished.",
  task_points: 1,
  montly_frequency: 7,
  start_date: Date.today,
  end_date: Date.today+30,
  user: user_2,
  task_template: template_1
)

Task.create!(
  name: "Setting table",
  description: "At 7 pm, set the table for dinner",
  task_points: 1,
  montly_frequency: 7,
  days: ["monday", "wednesday", "friday"],
  start_date: Date.today-62,
  end_date: Date.today-62,
  user: user_2,
  task_template: template_2
)

Task.create!(
  name: "Oil R2-D2",
  description: "Each month, put some oil inside R2-D2 collar",
  task_points: 4,
  status: true,
  validation: true,
  days: ["monday"],
  montly_frequency: 0,
  start_date: Date.today-62,
  end_date: Date.today-62,
  user: user_3,
  task_template: template_3
)

Task.create!(
  name: "Oil R2-D2",
  description: "Each month, put some oil inside R2-D2 collar",
  task_points: 4,
  status: true,
  validation: true,
  days: ["monday"],
  montly_frequency: 0,
  start_date: Date.today-30,
  end_date: Date.today-30,
  user: user_3,
  task_template: template_3
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
  task_template: template_3
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

Task.create!(
  name: "Go hunting",
  status: true,
  start_date: Date.today,
  end_date: Date.today+4,
  task_points: 4,
  montly_frequency: 0,
  user: user_5
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
  allergens: "gluten",
  photo: File.open(File.join(Rails.root,'app/assets/images/spaghetti_bolognese.jpg'))
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
  allergens: "dairy, gluten",
  photo: File.open(File.join(Rails.root,'app/assets/images/chicken_caesar_salad.jpg'))
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
  allergens: "soy",
  photo: File.open(File.join(Rails.root,'app/assets/images/vegetable_stir_fry.jpg'))
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
  allergens: "gluten, dairy, eggs",
  photo: File.open(File.join(Rails.root,'app/assets/images/pancakes.jpg'))
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
    Season the salmon fillet with salt, pepper, and mixed herbs.
    Heat olive oil in a pan over medium-high heat.
    Cook the salmon for 4 minutes each side until golden.
    Squeeze lemon juice over the fillet before serving.
  DESCRIPTION
  keywords: "fish, healthy, dinner",
  calories: 400,
  allergens: "fish",
  photo: File.open(File.join(Rails.root,'app/assets/images/grilled_salmon.jpg'))
)

recipe_6 = Recipe.create!(
  name: "Avocado Toast with Poached Eggs",
  ingredients: <<~INGREDIENTS,
    2 slices sourdough bread
    1 ripe avocado
    2 eggs
    1 tsp white vinegar
    1 tbsp lemon juice
    Red pepper flakes to taste
    Salt and pepper to taste
  INGREDIENTS
  description: <<~DESCRIPTION,
    Toast the sourdough slices until golden and crispy.
    Mash the avocado with lemon juice, salt, and pepper.
    Bring a pot of water with vinegar to a gentle simmer and poach the eggs for 3 minutes.
    Spread avocado on toast, top with poached eggs, and finish with red pepper flakes.
  DESCRIPTION
  keywords: "breakfast, healthy, eggs",
  calories: 320,
  allergens: "gluten, eggs",
  photo: File.open(File.join(Rails.root,'app/assets/images/avocado_toast.jpg'))
)

recipe_7 = Recipe.create!(
  name: "Overnight Oats with Berries",
  ingredients: <<~INGREDIENTS,
    80g rolled oats
    200ml milk
    100g mixed berries (fresh or frozen)
    2 tbsp honey
    50g Greek yogurt
    1 tbsp chia seeds
  INGREDIENTS
  description: <<~DESCRIPTION,
    Mix oats, milk, Greek yogurt, chia seeds, and honey in a jar.
    Stir well, cover, and refrigerate overnight.
    In the morning, top with fresh mixed berries and an extra drizzle of honey.
  DESCRIPTION
  keywords: "breakfast, meal prep, healthy",
  calories: 350,
  allergens: "dairy, gluten",
  photo: File.open(File.join(Rails.root,'app/assets/images/oats.jpg'))
)

recipe_8 = Recipe.create!(
  name: "Tomato Basil Soup",
  ingredients: <<~INGREDIENTS,
    800g canned crushed tomatoes
    1 onion, diced
    3 cloves garlic, minced
    200ml vegetable stock
    100ml heavy cream
    1 handful fresh basil
    2 tbsp olive oil
    Salt and pepper to taste
  INGREDIENTS
  description: <<~DESCRIPTION,
    Heat olive oil in a pot and sauté onion and garlic until soft.
    Add crushed tomatoes and vegetable stock and simmer for 20 minutes.
    Blend until smooth, stir in cream, and season with salt and pepper.
    Serve topped with fresh basil leaves.
  DESCRIPTION
  keywords: "lunch, soup, vegetarian",
  calories: 220,
  allergens: "dairy",
  photo: File.open(File.join(Rails.root,'app/assets/images/tomato_soup.jpg'))
)

recipe_9 = Recipe.create!(
  name: "Turkey Avocado Wrap",
  ingredients: <<~INGREDIENTS,
    1 large tortilla wrap
    120g sliced turkey breast
    1/2 avocado, sliced
    1 handful romaine lettuce
    1/2 tomato, sliced
    1 tbsp mayonnaise
    Salt and pepper to taste
  INGREDIENTS
  description: <<~DESCRIPTION,
    Lay the tortilla flat and spread mayonnaise evenly.
    Layer turkey, avocado, lettuce, and tomato.
    Season with salt and pepper, roll tightly, and slice in half.
  DESCRIPTION
  keywords: "lunch, wrap, quick",
  calories: 380,
  allergens: "gluten, eggs",
  photo: File.open(File.join(Rails.root,'app/assets/images/wrap.jpg'))
)

recipe_10 = Recipe.create!(
  name: "Chicken Tikka Masala",
  ingredients: <<~INGREDIENTS,
    400g chicken breast, cubed
    400ml coconut milk
    400g canned tomatoes
    1 onion, diced
    3 cloves garlic, minced
    2 tsp garam masala
    1 tsp turmeric
    1 tsp cumin
    2 tbsp olive oil
    Fresh coriander to serve
  INGREDIENTS
  description: <<~DESCRIPTION,
    Heat oil and sauté onion and garlic until golden.
    Add spices and cook for 1 minute until fragrant.
    Add chicken and brown on all sides.
    Pour in tomatoes and coconut milk, then simmer for 20 minutes.
    Serve with rice and fresh coriander.
  DESCRIPTION
  keywords: "dinner, curry, chicken",
  calories: 480,
  allergens: "none",
  photo: File.open(File.join(Rails.root,'app/assets/images/chicken_tikka_masala.jpg'))
)

recipe_11 = Recipe.create!(
  name: "Beef Tacos",
  ingredients: <<~INGREDIENTS,
    300g ground beef
    8 small corn tortillas
    1 tsp cumin
    1 tsp paprika
    1/2 tsp chili powder
    1 onion, diced
    1 tomato, diced
    100g shredded cheddar cheese
    Sour cream and salsa to serve
  INGREDIENTS
  description: <<~DESCRIPTION,
    Cook ground beef with onion, cumin, paprika, and chili powder until browned.
    Warm the tortillas in a dry pan for 30 seconds each side.
    Fill each tortilla with beef, diced tomato, and shredded cheese.
    Top with sour cream and salsa.
  DESCRIPTION
  keywords: "dinner, mexican, beef",
  calories: 520,
  allergens: "dairy, gluten",
  photo: File.open(File.join(Rails.root,'app/assets/images/tacos.jpg'))
)

recipe_12 = Recipe.create!(
  name: "Hummus with Veggie Sticks",
  ingredients: <<~INGREDIENTS,
    200g canned chickpeas
    2 tbsp tahini
    1 lemon, juiced
    1 clove garlic
    2 tbsp olive oil
    2 carrots, cut into sticks
    2 celery stalks, cut into sticks
    1 cucumber, cut into sticks
  INGREDIENTS
  description: <<~DESCRIPTION,
    Blend chickpeas, tahini, lemon juice, garlic, and olive oil until smooth.
    Season with salt and drizzle with olive oil to serve.
    Arrange carrot, celery, and cucumber sticks alongside the hummus.
  DESCRIPTION
  keywords: "snack, vegan, healthy",
  calories: 180,
  allergens: "sesame",
  photo: File.open(File.join(Rails.root,'app/assets/images/hummus.jpg'))
)

recipe_13 = Recipe.create!(
  name: "Banana Peanut Butter Smoothie",
  ingredients: <<~INGREDIENTS,
    2 ripe bananas
    2 tbsp peanut butter
    250ml milk
    1 tbsp honey
    4 ice cubes
  INGREDIENTS
  description: <<~DESCRIPTION,
    Add all ingredients to a blender.
    Blend on high for 1 minute until smooth and creamy.
    Pour into glasses and serve immediately.
  DESCRIPTION
  keywords: "snack, smoothie, quick",
  calories: 290,
  allergens: "peanuts, dairy",
  photo: File.open(File.join(Rails.root,'app/assets/images/smoothie.jpg'))
)

# puts "Generating AI photo..."


# [recipe_1, recipe_2, recipe_3, recipe_4, recipe_5,
#  recipe_6, recipe_7, recipe_8, recipe_9, recipe_10,
#  recipe_11, recipe_12, recipe_13].each do |recipe|
#   ImageGeneratorService.generate_and_attach(recipe)
#   sleep 2
# end

# puts "Generated photo successful!"


puts "Creating reward templates..."

RewardTemplate.create!(name: "Movie night",      description: "Pick a movie for the whole family to watch together", reward_points: 10, icon: "film")
RewardTemplate.create!(name: "Extra screen time", description: "30 minutes of bonus screen time",                         reward_points: 5,  icon: "controller")
RewardTemplate.create!(name: "Ice cream outing",  description: "A trip to the ice cream shop",                            reward_points: 15, icon: "gift")
RewardTemplate.create!(name: "New book",          description: "Choose a new book to read",                               reward_points: 20, icon: "book")
RewardTemplate.create!(name: "Sleep in Saturday", description: "No chores until noon on Saturday",                        reward_points: 8,  icon: "star-fill")
RewardTemplate.create!(name: "Pick dinner",       description: "Choose what the family eats for dinner",                  reward_points: 7,  icon: "cup-hot")

puts "Creating rewards..."

# Anakin (parent, #F5D2D2)
Reward.create!(name: "New book", description: "Choose a new book to read", reward_points: 20, icon: "book", redeemed: false, user: user_1)
Reward.create!(name: "Pick dinner", description: "Choose what the family eats for dinner", reward_points: 7, icon: "cup-hot", redeemed: true, redeemed_at: 3.days.ago, user: user_1)

# Leia (child, #F8F7BA)
Reward.create!(name: "Movie night", description: "Pick a movie for the whole family to watch together", reward_points: 10, icon: "film", redeemed: false, user: user_2)
Reward.create!(name: "Extra screen time", description: "30 minutes of bonus screen time", reward_points: 5, icon: "controller", redeemed: false, user: user_2)
Reward.create!(name: "Ice cream outing", description: "A trip to the ice cream shop", reward_points: 15, icon: "gift", redeemed: false, user: user_2)

# Luke (child, #A3CCDA)
Reward.create!(name: "Sleep in Saturday", description: "No chores until noon on Saturday", reward_points: 8, icon: "star-fill", redeemed: true, redeemed_at: 7.days.ago, user: user_3)
Reward.create!(name: "Movie night", description: "Pick a movie for the whole family to watch together", reward_points: 10, icon: "film", redeemed: false, user: user_3)

# Padme (parent, #BDE3C3)
Reward.create!(name: "Spa afternoon", description: "An afternoon off to relax", reward_points: 25, icon: "heart-fill", redeemed: false, user: user_4)
Reward.create!(name: "Pick dinner", description: "Choose what the family eats for dinner", reward_points: 7, icon: "cup-hot", redeemed: false, user: user_4)

# Sarabi (parent, #F5D2D2)
Reward.create!(name: "New book", description: "Choose a new book to read", reward_points: 20, icon: "book", redeemed: false, user: user_5)

# Simba (child, #F8F7BA)
Reward.create!(name: "Extra screen time", description: "30 minutes of bonus screen time", reward_points: 5, icon: "controller", redeemed: false, user: user_6)
Reward.create!(name: "Ice cream outing", description: "A trip to the ice cream shop", reward_points: 15, icon: "gift", redeemed: false, user: user_6)

puts "Creating Meal plans..."

meal_plan_today = MealPlan.find_or_create_by!(
  day: Date.today,
  family: family_1
)

meal_plan_tomorrow = MealPlan.find_or_create_by!(
  day: Date.today + 1,
  family: family_1
)

meal_plan_lion_king = MealPlan.find_or_create_by!(
  day: Date.today + 1,
  family: family_2
)

puts "Creating RecipeMealplans..."

# Today
RecipeMealPlan.create!(meal_plan: meal_plan_today, recipe: recipe_6,  meal_type: "Breakfast")
RecipeMealPlan.create!(meal_plan: meal_plan_today, recipe: recipe_12, meal_type: "Snack")
RecipeMealPlan.create!(meal_plan: meal_plan_today, recipe: recipe_8,  meal_type: "Lunch")
RecipeMealPlan.create!(meal_plan: meal_plan_today, recipe: recipe_1,  meal_type: "Dinner")

# Tomorrow
RecipeMealPlan.create!(meal_plan: meal_plan_tomorrow, recipe: recipe_4,  meal_type: "Breakfast")
RecipeMealPlan.create!(meal_plan: meal_plan_tomorrow, recipe: recipe_9,  meal_type: "Lunch")
RecipeMealPlan.create!(meal_plan: meal_plan_tomorrow, recipe: recipe_13, meal_type: "Snack")
RecipeMealPlan.create!(meal_plan: meal_plan_tomorrow, recipe: recipe_5,  meal_type: "Dinner")

# Lion King family
RecipeMealPlan.create!(meal_plan: meal_plan_lion_king, recipe: recipe_10, meal_type: "Dinner")

meal_plan_day2 = MealPlan.find_or_create_by!(day: Date.today + 2, family: family_1)
meal_plan_day3 = MealPlan.find_or_create_by!(day: Date.today + 3, family: family_1)
meal_plan_day4 = MealPlan.find_or_create_by!(day: Date.today + 4, family: family_1)
meal_plan_day5 = MealPlan.find_or_create_by!(day: Date.today + 5, family: family_1)
meal_plan_day6 = MealPlan.find_or_create_by!(day: Date.today + 6, family: family_1)

# Day 2
RecipeMealPlan.create!(meal_plan: meal_plan_day2, recipe: recipe_7,  meal_type: "Breakfast")
RecipeMealPlan.create!(meal_plan: meal_plan_day2, recipe: recipe_2,  meal_type: "Lunch")
RecipeMealPlan.create!(meal_plan: meal_plan_day2, recipe: recipe_12, meal_type: "Snack")
RecipeMealPlan.create!(meal_plan: meal_plan_day2, recipe: recipe_10, meal_type: "Dinner")

# Day 3
RecipeMealPlan.create!(meal_plan: meal_plan_day3, recipe: recipe_6,  meal_type: "Breakfast")
RecipeMealPlan.create!(meal_plan: meal_plan_day3, recipe: recipe_3,  meal_type: "Lunch")
RecipeMealPlan.create!(meal_plan: meal_plan_day3, recipe: recipe_13, meal_type: "Snack")
RecipeMealPlan.create!(meal_plan: meal_plan_day3, recipe: recipe_11, meal_type: "Dinner")

# Day 4
RecipeMealPlan.create!(meal_plan: meal_plan_day4, recipe: recipe_4,  meal_type: "Breakfast")
RecipeMealPlan.create!(meal_plan: meal_plan_day4, recipe: recipe_9,  meal_type: "Lunch")
RecipeMealPlan.create!(meal_plan: meal_plan_day4, recipe: recipe_5,  meal_type: "Dinner")

# Day 5
RecipeMealPlan.create!(meal_plan: meal_plan_day5, recipe: recipe_7,  meal_type: "Breakfast")
RecipeMealPlan.create!(meal_plan: meal_plan_day5, recipe: recipe_8,  meal_type: "Lunch")
RecipeMealPlan.create!(meal_plan: meal_plan_day5, recipe: recipe_12, meal_type: "Snack")
RecipeMealPlan.create!(meal_plan: meal_plan_day5, recipe: recipe_1,  meal_type: "Dinner")

# Day 6
RecipeMealPlan.create!(meal_plan: meal_plan_day6, recipe: recipe_6,  meal_type: "Breakfast")
RecipeMealPlan.create!(meal_plan: meal_plan_day6, recipe: recipe_2,  meal_type: "Lunch")
RecipeMealPlan.create!(meal_plan: meal_plan_day6, recipe: recipe_13, meal_type: "Snack")
RecipeMealPlan.create!(meal_plan: meal_plan_day6, recipe: recipe_3,  meal_type: "Dinner")


puts "Creating chats..."

chat_1 = Chat.create!(
  user: user_1,
  title: "High protein recipe",
)

chat_2 = Chat.create!(
  user: user_1,
  title: "Funny Breakfast",
)

chat_3 = Chat.create!(
  user: user_1,
  title: "Healthy snacks"
)

chat_4 = Chat.create!(
  user: user_1,
  title: "Quick lunch ideas"
)

chat_5 = Chat.create!(
  user: user_1,
  title: "Vegetarian recipes"
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
      "description": [
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
      "description": [
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
      "description": [
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

Message.create!(
  chat: chat_3,
  role: "user",
  content: "suggest me a healthy snack"
)

Message.create!(
  chat: chat_3,
  role: "assistant",
  content: '
    {
      "name": "Peanut Butter Apple Slices",
      "ingredients": [
        {"ingredient": "apple", "quantity": "1, sliced"},
        {"ingredient": "peanut butter", "quantity": "2 tbsp"},
        {"ingredient": "granola", "quantity": "1 tbsp"}
      ],
      "description": [
        "Wash and slice the apple into thin wedges.",
        "Spread peanut butter evenly on each slice.",
        "Sprinkle granola on top for added crunch.",
        "Serve immediately as a healthy snack."
      ],
      "keywords": ["snack", "healthy", "quick"],
      "calories": 250,
      "allergens": ["peanuts"]
    }
  '
)

Message.create!(
  chat: chat_4,
  role: "user",
  content: "give me a quick lunch recipe"
)

Message.create!(
  chat: chat_4,
  role: "assistant",
  content: '
    {
      "name": "Turkey Avocado Wrap",
      "ingredients": [
        {"ingredient": "tortilla wrap", "quantity": "1"},
        {"ingredient": "sliced turkey", "quantity": "100 g"},
        {"ingredient": "avocado", "quantity": "1/2, sliced"},
        {"ingredient": "lettuce", "quantity": "1 handful"},
        {"ingredient": "tomato", "quantity": "1/2, sliced"},
        {"ingredient": "mayonnaise", "quantity": "1 tbsp"}
      ],
      "description": [
        "Lay the tortilla flat on a clean surface.",
        "Spread mayonnaise evenly over the wrap.",
        "Layer turkey, avocado, lettuce, and tomato.",
        "Roll the wrap tightly and slice in half.",
        "Serve immediately."
      ],
      "keywords": ["lunch", "quick", "wrap"],
      "calories": 400,
      "allergens": ["gluten", "eggs"]
    }
  '
)

Message.create!(
  chat: chat_5,
  role: "user",
  content: "i want a vegetarian dinner"
)

Message.create!(
  chat: chat_5,
  role: "assistant",
  content: '
    {
      "name": "Chickpea Spinach Curry",
      "ingredients": [
        {"ingredient": "chickpeas (canned)", "quantity": "200 g"},
        {"ingredient": "spinach", "quantity": "100 g"},
        {"ingredient": "coconut milk", "quantity": "200 ml"},
        {"ingredient": "onion", "quantity": "1, diced"},
        {"ingredient": "garlic", "quantity": "2 cloves"},
        {"ingredient": "curry powder", "quantity": "1 tbsp"},
        {"ingredient": "olive oil", "quantity": "1 tbsp"}
      ],
      "description": [
        "Heat olive oil in a pan and sauté onion and garlic.",
        "Add curry powder and cook for 1 minute.",
        "Add chickpeas and coconut milk, then simmer for 10 minutes.",
        "Stir in spinach and cook until wilted.",
        "Serve hot with rice or bread."
      ],
      "keywords": ["vegetarian", "dinner", "curry"],
      "calories": 380,
      "allergens": []
    }
  '
)


puts "Finished! Created #{Task.count} tasks, #{Recipe.count} recipes and #{Reward.count} rewards, #{MealPlan.count} meal plans, #{RecipeMealPlan.count} recipemealplans, #{Chat.count} chat(s) and #{Message.count} messages!"
