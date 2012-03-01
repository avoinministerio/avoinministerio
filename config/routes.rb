AvoinMinisterio::Application.routes.draw do
  match "/ideas/:id/vote/:vote"     => "vote#vote", as: :vote_idea

  get "pages/home"

  get "ideas/vote_flow"

  devise_for :citizens, :controllers => { :omniauth_callbacks => "citizens/omniauth_callbacks" }
  
  resources :ideas do
    resources :comments
  end
  resources :articles

  devise_for :administrators
  
  match "/admin", to: "admin/ideas#index", as: :administrator_root
  namespace :admin do
    resources :ideas do
      get "publish",    on: :member
      get "unpublish",  on: :member
      get "moderate",   on: :member
      resources :comments do
        get "publish",    on: :member
        get "unpublish",  on: :member
        get "moderate",   on: :member
      end
    end
    resources :comments do
      get "publish",    on: :member
      get "unpublish",  on: :member
      get "moderate",   on: :member
    end
    resources :citizens do
      get "lock",       on: :member
      get "unlock",     on: :member
    end
    
    root to: "admin/ideas#index"
  end

  root to: "pages#home"
end

ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml', { :no_prefixes => true })
