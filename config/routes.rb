InspectionsOuvert::Application.routes.draw do
  filter :locale

  resources :establishments, :only => [:index, :show]
  resources :owners, :only => [:index, :show]

  match 'about' => 'pages#about'
  match 'statistics' => 'pages#statistics'

  root :to => 'pages#home'
end
