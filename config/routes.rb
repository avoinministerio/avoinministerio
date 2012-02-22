AvoinMinisterio::Application.routes.draw do
  match "/ideas/:id/vote/:vote"     => "vote#vote", as: :vote_idea

  get "pages/home"

  devise_for :citizens, :controllers => { :omniauth_callbacks => "citizens/omniauth_callbacks" }
  
  localized do
    resources :ideas do
      resources :comments
    end
  end

  root to: "pages#home"
end
