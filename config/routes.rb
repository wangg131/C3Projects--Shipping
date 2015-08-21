Rails.application.routes.draw do

  get '/' => 'packages#estimate_request'
  patch '/save' => 'packages#save'

end
