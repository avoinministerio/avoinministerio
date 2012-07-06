AvoinMinisterio::Application.routes.draw do

  resource :profile, :except => [:new, :create, :destroy]  
  resource :citizen, :only => [:edit, :update]

  match "/ideas/:id/vote/:vote"                       => "vote#vote",                     as: :vote_idea

  match "/ideas/:id/introduction"                     => "signatures#introduction",       via: :get,  as: :signature_idea_introduction
  match "/ideas/:id/approval"                         => "signatures#approval",           via: :post, as: :signature_idea_approval
  match "/ideas/:id/signature"                        => "signatures#sign",               via: :post, as: :signature_idea
  match "/signatures/:id/finalize_signing"            => "signatures#finalize_signing",   via: :put
  match "/signatures/:id/returning/:servicename"      => "signatures#returning",          via: :get
  match "/signatures/:id/cancelling/:servicename"     => "signatures#cancelling",         via: :get
  match "/signatures/:id/rejecting/:servicename"      => "signatures#rejecting",          via: :get

  match "/ideas/:id/shortcutfillin"                   => "signatures#shortcut_fillin",            via: :get, as: :signature_idea_shortcut_fillin
  match "/signatures/:id/shortcut_finalize_signing"   => "signatures#shortcut_finalize_signing",  via: :put, as: :signature_shortcut_finalize_signing


  match "/ideat/haku" => "ideas#search"
  get "ideas/vote_flow"

  get "pages/home"

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
