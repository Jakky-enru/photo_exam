Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :favorites, only: [:create, :destroy, :index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :pictures do
    collection do
      post :confirm
    end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

