class HomeController < ApplicationController
  
  around_filter :shopify_session, :except => 'welcome'

  def welcome
    current_host = "#{request.host}#{':' + request.port.to_s if request.port != 80}"
    @callback_url = "http://#{current_host}/login"
  end
  
  def index
    init_shop
    # get latest 5 orders
    @orders   = ShopifyAPI::Order.find(:all, :params => {:limit => 3, :order => "created_at DESC" })
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
    end
    #init_webhooks
  end
  
  def init_webhooks
    #ex: "products/update", "products/delete"
    #topics = ["orders/create"]
    #topics.each do |topic|
    #  webhook = ShopifyAPI::Webhook.create(:format => "json", :topic => topic, :address => "http://#{DOMAIN_NAMES[RAILS_ENV]}/webhooks/#{topic}")
    #  raise "Webhook invalid: #{webhook.errors}" unless webhook.valid?
    #end
    
    #change this in prod
    address="http://3jru.localtunnel.com/payments"
    
    webhook = ShopifyAPI::Webhook.create(:format => "json",  :topic => "webhooks/create", :address => address)
    if webhook.valid?
      logger.debug("oh Webhook invalid: #{webhook.errors}")
    else
      logger.debug('Created webhook')
    end
  end
end