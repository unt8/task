Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'welcome#index'
  root 'user#index'

  get '/user/callback', to: 'user#callback'
  get '/user/test_token', to: 'user#test_token'
end
