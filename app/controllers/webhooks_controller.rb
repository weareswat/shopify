#encoding utf-8
class WebhooksController < ApplicationController

  #before_filter :verify_webhook, :except => 'verify_webhook'
 

  def create
    #data = ActiveSupport::JSON.decode(request.body.read)
    #debugger
    if !request.nil? && request.filtered_parameters["id"]!=nil
      shop=Shop.where(:store_url => request.headers['x-shopify-shop-domain']).first

      #save this for backup
      webhook=Webhook.new(:params=>request.filtered_parameters, :security=>request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'], :shop_url=>request.headers['x-shopify-shop-domain'],  :order_id=>request.filtered_parameters["id"])
      webhook.save

      unless shop.nil?
        session = ShopifyAPI::Session.new(shop.store_url, shop.token)
        ShopifyAPI::Base.activate_session(session)
        order=ShopifyAPI::Order.find( request.filtered_parameters["id"] )
        
        if send_to_invoicexpress(shop, order, webhook)
          head :ok
        else
          #something went wrong ho ho
          render status: 500
        end
      else
        #no shop found
        render status: 404
      end        
    else
      #no request with suficient information
      render status: 404
    end
  end

  private

  #note: could this be on a module? or in the model?
  def send_to_invoicexpress(shop, order, webhook)
    existing_invoices = Invoice.where(:order_id=>order.id)
    if existing_invoices && existing_invoices.size>0
      true
    else
      invoice=Invoice.new(
        :store_url=>    shop.store_url, 
        :order_id=>     order.id,
        :shop_id=>      shop.id, 
        :order_number=> order.name,
        :total=>        order.total_price, 
        :email=>        order.email,
        :name=>         "#{order.customer.first_name} #{order.customer.last_name}"
      )
      invoice.create_invoicexpress()
      if invoice.save
        invoice.send_email if shop.auto_send_email==true
        #complete this information if possible
        webhook.shop_id     = shop.id
        webhook.invoice_id  = invoice.id
        webhook.save
        true
      else
        false
      end
    end
    
  end

  def verify_webhook
    data = request.body.read.to_s
    hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    digest  = OpenSSL::Digest::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, Invoicexpress::Application.config.shopify.secret, data)).strip
    unless calculated_hmac == hmac_header
      head :unauthorized
    end
    request.body.rewind
  end
end
