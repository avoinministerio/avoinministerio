AvoinMinisterio::Application.routes.draw do
  match "/ideas/:id/vote/:vote"     => "vote#vote", as: :vote_idea

  get "pages/home"

  get "ideas/vote_flow"

  devise_for :citizens, :controllers => { :omniauth_callbacks => "citizens/omniauth_callbacks" }
  
  localized do
    resources :ideas do
      resources :comments
    end
    resources :articles
  end

  devise_for :administrators
  
  namespace :admin do
    resources :ideas do
      get "publish",    on: :member
      get "unpublish",  on: :member
      get "moderate",   on: :member
      resources :comments
    end
    resources :comments do
      get "publish",    on: :member
      get "unpublish",  on: :member
      get "moderate",   on: :member
    end
    resources :citizens
    
    root to: "admin/ideas#index"
  end

  root to: "pages#home"
end
