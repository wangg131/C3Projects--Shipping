Rails.application.routes.draw do
  resources :destinations
  resources :packages

  get '/' => 'application#estimate_request'
  post '/package' => 'package#create'
  post '/destination' => 'destination#create'

end
