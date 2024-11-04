Rails.application.routes.draw do
  resources :tasks do
    member do
      patch :toggle
    end
  end
end
    