AvoinMinisterio::Application.routes.draw do
  get "pages/home"

  devise_for :citizens

  root to: "pages#home"
end
