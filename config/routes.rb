Rails.application.routes.draw do
 
  namespace :admins_backoffice do
    resources :admins, only:[:index, :edit, :update]
  end
  namespace :site do
    get 'welcome/index'
  end
  
  namespace :users_backoffice do
    get 'welcome/index'
  end


 namespace :admins_backoffice do
    get 'welcome/index'
  end

  devise_for :admins
  devise_for :users
  
  root 'site/welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
