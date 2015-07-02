Rails.application.routes.draw do
  devise_for :users
  resources :users

  authenticate :user, lambda { |u| Rails.logger.info("AUTHING #{u}"); u.id == 2 } do # TODO real auth
    mount Upmin::Engine => '/admin'
  end

  root to: 'visitors#index'

  resources :substances
  resources :statutes
  resources :substance_statutes
end
