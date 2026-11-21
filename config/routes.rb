Rails.application.routes.draw do
  get "schedule_items/index"
  get "schedule_items/new"
  get "schedule_items/edit"
  get "schedule_items/_form"
  devise_for :users
  resource :profile, only: %i[edit update]
  resources :journal_entries, path: "diario", except: :show
  resources :ranks, only: :index
  resources :schedule_items, path: "agenda", except: :show
  resource :status, only: :show do
    post :allocate
  end

  resources :workouts, path: "treinos" do
    resources :exercises, path: "exercicios", except: %i[index show] do
      resource :completion, only: :create, controller: "exercise_completions"
    end
  end

  resources :habits, except: [ :show ] do
    resource :completion, only: :create
  end

  resources :rewards, except: :show do
    resource :purchase, only: :create
  end

  root "habits#index"
end
