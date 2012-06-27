AvoinMinisterio::Application.routes.draw do

  get "profiles/edit"
  put "profiles/update_password"

  match "/ideas/:id/vote/:vote"                       => "vote#vote",               as: :vote_idea

  match "/ideas/:id/introduction"                     => "signatures#introduction", as: :signature_idea_introduction
  match "/ideas/:id/approval"                         => "signatures#approval",     as: :signature_idea_approval
  match "/ideas/:id/signature"                        => "signatures#sign",         as: :signature_idea
  match "/signatures/:id/finalize_signing"            => "signatures#finalize_signing"
  match "/signatures/:id/:returncode/:servicename"    => "signatures#back"

  match "/ideat/haku" => "ideas#search"
  get "ideas/vote_flow"

  get "pages/home"


  resources :signatures   # TODO FIX FIXME: this is very dangerous route if controller#destroy will be defined

  resources :signatures   # TODO FIX FIXME: this is very dangerous route if controller#destroy will be defined

  resources :signatures   # TODO FIX FIXME: this is very dangerous route if controller#destroy will be defined

  devise_for :citizens, :controllers => { 
    omniauth_callbacks: "citizens/omniauth_callbacks",
    registrations: "citizens/registrations",
    sessions: "citizens/sessions",
  }
  
  resources :ideas do
    resources :comments
    resources :expert_suggestions, only: [:new, :create]
  end
  resources :articles do
    resources :comments
  end

  devise_for :administrators
  
  match "/admin", to: "admin/ideas#index", as: :administrator_root

  namespace :admin do
    resources :articles do
      get "publish",    on: :member
      get "unpublish",  on: :member
      get "moderate",   on: :member
    end
    resources :comments do
      get "publish",    on: :member
      get "unpublish",  on: :member
      get "moderate",   on: :member
    end
    resources :ideas do
      resources :articles do
        get "publish",    on: :member
        get "unpublish",  on: :member
        get "moderate",   on: :member        
      end
      resources :comments do
        get "publish",    on: :member
        get "unpublish",  on: :member
        get "moderate",   on: :member
      end
      
      get "publish",    on: :member
      get "unpublish",  on: :member
      get "moderate",   on: :member
    end
    resources :citizens do
      get "lock",       on: :member
      get "unlock",     on: :member
    end
    resources :changelogs
    resources :expert_suggestions
    root to: "admin/ideas#index"
  end

  root to: "pages#home"
end

ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml', { :no_prefixes => true })
