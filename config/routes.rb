AirbnbAid::Application.routes.draw do
  root 'welcome#index'

  get 'join',     :controller => 'users',    :action => 'new',     :as => :join
  get 'sign_in',  :controller => 'sessions', :action => 'new',     :as => :sign_in
  get 'sign_out', :controller => 'sessions', :action => 'destroy', :as => :sign_out

  resource :dashboard, :only => :show

  resources :users,    :only => :create
  resources :sessions, :only => :create
  resources :listings
end
