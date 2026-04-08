Rails.application.routes.draw do
  get 'calendars/index'
  get 'calendars/show'

  # devise_for :users
  devise_for :users, :controllers => { registrations: 'users/registrations' }

  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :recipes, only: [:index, :new, :create, :show, :destroy]

  resources :chats, only: [:index, :create, :show] do
    resources :messages, only: [:create]
  end

  resources :tasks
  resources :task_templates, only: [:index, :show, :destroy, :edit, :update]

  resources :reward_templates, only: [:index, :new, :create, :destroy]

  resources :rewards, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    member do
      patch :redeem
    end
  end

  resources :meal_plans, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  resources:families do
    resources :member, only: [:index, :show, :new, :create]
    end

    resources :task_templates, only: [:new, :create]

  resources :recipe_meal_plans, only: [:destroy, :edit, :update]

end
