AvoinMinisterio::Application.routes.draw do
  match "/ideas/:id/vote/:vote"     => "vote#vote", as: :vote_idea

  get "pages/home"

  get "ideas/vote_flow"

  devise_for :citizens, :controllers => { :omniauth_callbacks => "citizens/omniauth_callbacks" }
  
  localized do
    resources :ideas do
      resources :comments
    end
  end

  devise_for :administrators
  
  namespace :admin do
    resources :ideas
    resources :comments
    resources :citizens
    
    root to: "admin/ideas#index"
  end

  root to: "pages#home"
end
