Rails.application.routes.draw do
  resources :book

  post '/main_bot' => 'main_bot#index'
end
