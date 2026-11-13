Rails.application.routes.draw do
  devise_for :users
  resource :profile, only: %i[edit update]

  resources :habits, except: [ :show ] do
    resource :completion, only: :create
  end

  resources :rewards, except: :show do
    resource :purchase, only: :create
  end

  root "habits#index"
end
