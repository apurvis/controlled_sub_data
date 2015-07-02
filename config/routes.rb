Rails.application.routes.draw do
  devise_for :users
  resources :users

  authenticate :user, lambda { |u| u.id == 2 } do # TODO real auth
    Rails.logger.info("AUTHING #{u}")
    mount Upmin::Engine => '/admin'
  end

  root to: 'visitors#index'
end
