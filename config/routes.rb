AvoinMinisterio::Application.routes.draw do
  get "pages/home"

  devise_for :citizens
  
  localized do
    resources :ideas do
      resources :comments
    end
  end

  root to: "ideas#index"
end
