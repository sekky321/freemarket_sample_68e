Rails.application.routes.draw do
  get 'purchase/index'
  get 'purchase/done'
  devise_for :users
  root 'items#index'
  resources :items do
    resources :purchase, only: [:index] do
      collection do
        get 'index', to: 'purchase#index' 
        post 'pay', to: 'purchase#pay'
        get 'done', to: 'purchase#done'
      end
    end
    resources :comments, only: :create
  end
  resources :card, only: [:new, :show] do
    collection do
      post 'show', to: 'card#show'
      post 'pay', to: 'card#pay'
      post 'delete', to: 'card#delete'
    end
  end
  resources :users, only: [:show, :create, :new] do
    collection do
      get 'logout'
      get 'card'
    end
  end
end
