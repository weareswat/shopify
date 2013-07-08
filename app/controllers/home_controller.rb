class HomeController < ApplicationController
  
  around_filter :shopify_session, :except => 'welcome'

  def welcome
    current_host = "#{request.host}#{':' + request.port.to_s if request.port != 80}"
    @callback_url = "http://#{current_host}/login"
  end
  
  def index
    init_shop
    # get latest 5 orders
    @orders   = ShopifyAPI::Order.find(:all, :params => {:limit => 5, :order => "created_at DESC" })
  end

  def setup
    @shop=Shop.where(:store_url => ShopifyAPI::Shop.current.domain).first
  end

  private
  def init_shop
    if Shop.where(:name => ShopifyAPI::Shop.current.name).exists?
      @shop=Shop.where(:store_url => ShopifyAPI::Shop.current.domain).first
      session[:shop]=@shop.name
    else
      @shop = Shop.new(:name => ShopifyAPI::Shop.current.name, :store_url => ShopifyAPI::Shop.current.domain)
      @shop.save
      session[:shop] = @shop.name
      #init_webhooks
      redirect_to setup_path()
    end
  end
  
  def init_webhooks
    #change this in production!
    #address=""
    address="https://thinkorange.pagekite.me/webhooks"
    
    webhook = ShopifyAPI::Webhook.create(:format => "json",  :topic => "orders/paid", :address => address)
    if webhook.valid?
      #debugger
      logger.debug("oh Webhook invalid: #{webhook.errors}")
    else
      logger.debug('Created webhook')
    end
  end
end