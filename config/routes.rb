Rails.application.routes.draw do
  resources :meetups
  root 'meetups#new'
end
