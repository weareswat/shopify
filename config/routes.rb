Invoicexpress::Application.routes.draw do
  
  match 'welcome' => 'home#welcome'
  match 'debug'   => 'home#debug'
  match 'setup'   => 'home#setup'
  match 'help'    => 'help#index'
  match 'wizard'  => 'wizard#step1'
  match 'trouble' => 'home#trouble'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'auth/shopify/callback' => :show
    delete 'logout' => :destroy
  end

  resources :invoices do
    member do
      post 'send_email'
    end
  end

  resources :webhooks
  resources :shops

  root :to => 'home#index'

end
