AvoinMinisterio::Application.routes.draw do

  resource :profile, :except => [:new, :create, :destroy]  
  resource :citizen, :only => [:edit, :update]
  
  match "/citizens/list_of_politicians.json"          => "citizens#list_of_politicians", via: :get
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


  match "/ideat/haku" => "ideas#search"
  get "ideas/vote_flow"

  get "pages/home"
  
  get 'tags/:tag', to: 'ideas#index', as: :tag
  get '/tags.json', to: 'tags#index'
  post '/ideas/lda', to: 'ideas#lda'
  post '/ideas/suggest_tags', to: 'ideas#suggest_tags'

  #match '/ideas/:id/vote_for/:tag_id' => 'tags#vote_for', via: :post, as: :vote_for_tag
  
  devise_for :citizens, :controllers => { 
    omniauth_callbacks: "citizens/omniauth_callbacks",
    registrations: "citizens/registrations",
    sessions: "citizens/sessions",
  }
  match "/citizens/after_sign_up" => "citizens#after_sign_up", via: :get
  
  resources :tags do
    get "vote_for", on: :member
    get "vote_against", on: :member
    get "show_more", on: :member
    post "list_of_suggested", on: :member
    get "add_to_suggested", on: :member
  end
  
  resources :ideas do
    get :politician_vote_for, on: :member
    get :politician_vote_against, on: :member
    post :upload_document, on: :member
    get :adopt_the_initiative, on: :member
    post "lda", on: :member
    post "suggest_tags", on: :member
    resources :comments
    resources :expert_suggestions, only: [:new, :create]
  end
  resources :articles do
    resources :comments
  end
 
  resources :documents

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
      get "change_role_politician", on: :member
      get "change_role_citizen", on: :member
      get "lock",                   on: :member
      get "unlock",                 on: :member
    end
    resources :changelogs
    resources :expert_suggestions
    root to: "admin/ideas#index"
  end

  root to: "pages#home"
end

ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml', { :no_prefixes => true })
