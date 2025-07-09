# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
                 controllers: {
                   registrations: 'api/v1/registrations',
                   sessions: 'api/v1/sessions'
                 },
                 skip: [:passwords, :confirmations],
                 path: '',
                 path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   registration: 'signup'
                 }

      devise_scope :user do
        post '/login',  to: 'api/v1/sessions#create'
        delete '/logout', to: 'api/v1/sessions#destroy'
      end

      get 'meals/random', to: 'meals#random'
      resources :meals, only: [:show]

      resources :meal_histories, only: [:index, :update]

      resources :users, only: [] do
        get :preferences, on: :collection
      end
    end
  end
end
