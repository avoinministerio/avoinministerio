AvoinMinisterio::Application.routes.draw do
  get "pages/home"

  devise_for :citizens
  
  resources :ideas

  root to: "pages#home"
end
