Rapidfire::Engine.routes.draw do
  resources :surveys do
    get 'results', on: :member

    resources :questions
    resources :attempts, only: [:new, :create]
  end

  root :to => "surveys#index"
end
