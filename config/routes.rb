Rails.application.routes.draw do
  resources :technologies
  resources :meetups
  root 'meetups#new'
end
