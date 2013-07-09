#encoding utf-8
class WebhooksController < ApplicationController

  #before_filter :verify_webhook, :except => 'verify_webhook'


  def create
    #data = ActiveSupport::JSON.decode(request.body.read)
    #debugger
    if !request.nil? && request.filtered_parameters["id"]!=nil
      shop=Shop.where(:email => request.filtered_parameters["email"]).first
      unless shop.nil?
        session = ShopifyAPI::Session.new(shop.store_url, shop.token)
        ShopifyAPI::Base.activate_session(session)
        order=ShopifyAPI::Order.find( request.filtered_parameters["id"] )
        @invoice=Invoice.new(
          :store_url=> shop.store_url, 
          :order_id=> order.id,
          :shop_id=> shop.id, 
          :order_number=> order.name,
          :total=>  order.total_price, 
          :email=>  order.email,
          :name=> "#{order.customer.first_name} #{order.customer.last_name}"
        )
        @invoice.create_invoicexpress()
        if @invoice.save
          head :ok
        end
      end        
    end
  end

  private
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
