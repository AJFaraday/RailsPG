RubyPG::Application.routes.draw do

  root :to => 'application#index'

  resources :adventures, :only => [:index, :show]
  resources :games, :only => [:index, :new,:destroy] do
    member do
      get :play
      get :move
      get :turn
    end
  end

end
