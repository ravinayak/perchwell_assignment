# frozen_string_literal: true

# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :buildings, only: %i[index create update]
    end
  end
end
