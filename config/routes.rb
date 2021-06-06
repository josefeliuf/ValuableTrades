Rails.application.routes.draw do
  get 'tables/index'
  root 'tables#index'
end
