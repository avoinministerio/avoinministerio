AvoinMinisterio::Application.routes.draw do

  resource :profile, :except => [:new, :create, :destroy]  
  resource :citizen, :only => [:edit, :update]
  match "/ideas/:id/vote/:vote"                       => "vote#vote",                     as: :vote_idea

  match "/ideas/:id/service_selection"                => "signatures#service_selection",      as: :signature_idea_service_selection
  match "/ideas/:id/introduction"                     => "signatures#introduction",           via: :get,  as: :signature_idea_introduction
  match "/ideas/:id/approval"                         => "signatures#approval",               via: :post, as: :signature_idea_approval
  match "/ideas/:id/signature"                        => "signatures#sign",                   via: :post, as: :signature_idea

  match "/signatures/:id/selected_free_service"       => "signatures#selected_free_service",  via: :get,  as: :signature_idea_selected_free_service
  match "/signatures/:id/selected_costly_service"     => "signatures#selected_costly_service",via: :get,  as: :signature_idea_selected_costly_service
  match "/signatures/:id/successful_authentication"   => "signatures#successful_authentication", via: :get,  as: :signature_idea_successful_authentication
  match "/signatures/:id/signing_success"             => "signatures#signing_success",        via: :get,  as: :signature_idea_signing_success
  match "/signatures/:id/signing_failure"             => "signatures#signing_failure",        via: :get,  as: :signature_idea_signing_failure
  match "/signatures/:id/shortcutting_to_signing"     => "signatures#shortcutting_to_signing",via: :get,  as: :signature_idea_shortcutting_to_signing


  match "/signatures/:id/finalize_signing"            => "signatures#finalize_signing",       via: :put
  match "/signatures/:id/returning/:servicename"      => "signatures#returning",              via: :get
  match "/signatures/:id/cancelling/:servicename"     => "signatures#cancelling",             via: :get
  match "/signatures/:id/rejecting/:servicename"      => "signatures#rejecting",              via: :get

  match "/ideas/:id/shortcutfillin"                   => "signatures#shortcut_fillin",            via: :get, as: :signature_idea_shortcut_fillin
  match "/signatures/:id/shortcut_finalize_signing"   => "signatures#shortcut_finalize_signing",  via: :put, as: :signature_shortcut_finalize_signing

  # Was via: :get but Sampo requires also post
  match "/signatures/:id/paid_returning/:servicename"   => "signatures#paid_returning"
  match "/signatures/:id/paid_canceling/:servicename"   => "signatures#paid_canceling"
  match "/signatures/:id/paid_rejecting/:servicename"   => "signatures#paid_rejecting"

  match "/kartta" => "locations#map"
  match "/osoitteet" => "locations#addresses"

  match '/conversations/inbox' => 'conversations#show_inbox'
  match '/conversations/sentbox' => 'conversations#show_sentbox'
  match '/conversations/trash' => 'conversations#show_trash'

  match "/ideat/haku" => "ideas#search"
  get "ideas/vote_flow"

  get "pages/home"

  devise_for :citizens, :controllers => { 
    omniauth_callbacks: "citizens/omniauth_callbacks",
    registrations: "citizens/registrations",
    sessions: "citizens/sessions",
  }
  match "/citizens/after_sign_up" => "citizens#after_sign_up", via: :get

  resources :ideas do
    resources :comments
    resources :expert_suggestions, only: [:new, :create]
  end
  resources :articles do
    resources :comments
  end
  
  get '/get_participants.json', to: 'conversations#get_participants'

  resources :conversations, only: [:index, :show, :new, :create] do
    post :reply,   on: :member
    get :trash,    on: :member
    get :untrash,  on: :member
  end

  resources :locations

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
    resources :locations
    resources :changelogs
    resources :expert_suggestions
    root to: "admin/ideas#index"
  end

  root to: "pages#home"
end

ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml', { :no_prefixes => true })
