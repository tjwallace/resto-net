InspectionsOuvert::Application.routes.draw do
  filter :locale

  resources :establishments, :only => [:index, :show] do
    get :embed, :on => :collection
  end

  resources :owners, :only => [:index, :show]

  match 'embed' => 'pages#embed'
  match 'about' => 'pages#about'
  match 'statistics' => 'pages#statistics'
  match 'api' => 'pages#api'

  root :to => 'pages#home'
end
