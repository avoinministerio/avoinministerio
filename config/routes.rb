AvoinMinisterio::Application.routes.draw do
  get "pages/home"

  devise_for :citizens
  
  localized do
    resources :ideas
  end
  
  root to: "pages#home"
end
