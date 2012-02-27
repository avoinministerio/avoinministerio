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

  root to: "pages#home"
end
