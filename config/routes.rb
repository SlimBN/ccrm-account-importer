Rails.application.routes.draw do

  namespace :admin do
    resources :import_accounts
  end
end
