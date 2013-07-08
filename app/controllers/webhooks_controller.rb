#encoding utf-8
class WebhooksController < ApplicationController

  #before_filter :verify_webhook, :except => 'verify_webhook'


  def create
    #data = ActiveSupport::JSON.decode(request.body.read)
    #debugger
    if !request.nil? && request.filtered_parameters["id"]!=nil
      #order=ShopifyAPI::Order.find( request.filtered_parameters["id"] )
    end
    head :ok
  end

  private
  def send_to_invoicexpress(shop, order)
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
      if shop.auto_send_email
        invoice.send_email
      end
      true
    else
      false
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
