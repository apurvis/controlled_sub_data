Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :audits

  #authenticate :user, lambda { |u| u.admin? } do
  #  mount Upmin::Engine => '/admin'
  #end

  root to: 'visitors#index'

  resources :statute_comparisons
  resources :statute_searches

  resources :statutes
  resources :statute_amendments

  resources :substances
  resources :substance_alternate_names
  resources :substance_statutes
  resources :substance_classifications

  resources :schedule_levels
end
