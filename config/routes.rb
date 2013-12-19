Rapidfire::Engine.routes.draw do
  resources :surveys do
    resources :questions
    resources :attempts, only: [:new, :create, :update]
  end

  resources :activities, controller: 'attempts'
  root :to => "surveys#index"
end
