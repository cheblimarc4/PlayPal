Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "/your_requests", to: "matches#yourequest"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :matches, only: [:index, :show, :new, :create] do
    resources :user_matches, only: [:create]
  end

  get "my_matches", to: "matches#mymatches"
  get "cancelmymatch/:id", to: "user_matches#cancel_match"
  get "acceptusermatch/:id", to: "user_matches#acceptuser"
  get "rejectusermatch/:id", to: "user_matches#rejectuser"
end
