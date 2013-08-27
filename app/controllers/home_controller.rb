class HomeController < ApplicationController
  
  around_filter :shopify_session, :except => 'welcome'

  def welcome
    current_host = "#{request.host}#{':' + request.port.to_s if request.port != 80}"
    @callback_url = "http://#{current_host}/login"
  end
  
  # get latest orders
  def index
    init_shop
    @orders = ShopifyAPI::Order.paginate per: 6, page: params[:page], params: {:order => "created_at DESC"}
    order_ids   = @orders.map(&:id)
    @db_invoices  = @shop.invoices.where(:order_id => order_ids)
  end

  def setup
    @shop=Shop.where(:store_url => ShopifyAPI::Shop.current.domain).first
  end
  
  def debug
    @shop=Shop.where(:store_url => ShopifyAPI::Shop.current.domain).first
    @hooks= ShopifyAPI::Webhook.all
    @webhooks= Webhook.where(:shop_url=>ShopifyAPI::Shop.current.domain).page params[:page]
  end

  private
  def init_shop
    #debugger
    if Shop.where(:store_url => ShopifyAPI::Shop.current.domain).exists?

      @shop=Shop.where(:store_url => ShopifyAPI::Shop.current.domain).first
      
      if session["shopify"] && session["shopify"].token != @shop.token
        @shop.token=session["shopify"].token
        @shop.save
      end
    
    else
      
      @shop           = Shop.new(:name => ShopifyAPI::Shop.current.name, :store_url => ShopifyAPI::Shop.current.domain)
      @shop.token     = session["shopify"].token if session["shopify"] 
      @shop.email     = ShopifyAPI::Shop.current.email
      @shop.store_id  = ShopifyAPI::Shop.current.id
      @shop.save

      init_webhooks
      session[:shop] = @shop.name
      redirect_to setup_path()
    end
  end
  
  def init_webhooks
    #change this in production!
    #address=""
    if Rails.env.development?
      address="https://thinkorange.pagekite.me/webhooks"
    else
      address="http://shopinvoicexpress.herokuapp.com/webhooks"
    end  

    webhook = ShopifyAPI::Webhook.create(:format => "json",  :topic => "orders/paid", :address => address)
    if webhook.valid?
      #debugger
      logger.debug("oh Webhook invalid: #{webhook.errors}")
    else
      logger.debug('Created webhook')
    end
  end
end