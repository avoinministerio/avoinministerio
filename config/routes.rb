AvoinMinisterio::Application.routes.draw do
  match "/vote/vote_for/:idea" 		=> "vote#vote_for"
  match "/vote/vote_against/:idea" 	=> "vote#vote_against"

  get "pages/home"

  get "ideas/vote_flow"

  devise_for :citizens, :controllers => { :omniauth_callbacks => "citizens/omniauth_callbacks" }
  
  localized do
    resources :ideas do
      resources :comments
    end
  end

  root to: "pages#home"
end
