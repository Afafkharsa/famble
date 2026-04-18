Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root to: "pages#home"

  # Health check — used by uptime monitors
  get "up" => "rails/health#show", as: :rails_health_check

  resources :recipes

  resources :chats, only: [:index, :create, :show, :destroy] do
    resources :messages, only: [:create]
  end

  resources :tasks, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :task_templates, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :reward_templates, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :rewards, only: [:index, :new, :create, :edit, :update, :destroy] do
    member { patch :redeem }
  end

  resources :point_adjustments, only: :create do
    collection { post :reset }
  end

  resources :users, only: [] do
    member { patch :update_color }
  end

  resources :meal_plans, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :recipe_meal_plans, only: [:edit, :update, :destroy]

  resources :families, only: [:index, :show, :new, :create]

  resources :calendars, only: :index do
    collection { get :day_detail }
  end

  resources :events, only: [:index, :new, :create, :edit, :update, :destroy]
end
