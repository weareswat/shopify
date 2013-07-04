Invoicexpress::Application.routes.draw do
  
  match 'welcome' => 'home#welcome'
  match 'design' => 'home#design'
  match 'setup' => 'home#setup'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'auth/shopify/callback' => :show
    delete 'logout' => :destroy
  end

  root :to => 'home#index'

  resources :invoices do
    member do
      post 'send_email'
    end
  end
  resources :webhooks
  resources :shops
  
end
