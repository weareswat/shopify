class InvoicesController < ApplicationController

  around_filter :shopify_session
  before_filter :load_shop

  #TODO
  #add pagination, search?
  def index
    @invoices = Invoice.all   
  end

  def new
    @payment = nil
    order   = nil

    if @shop && params[:order_id]
      order = ShopifyAPI::Order.find(params[:order_id])
      if order
        #fill general data
        #debugger
        @invoice=Invoice.new(
          :store_url=>ShopifyAPI::Shop.current.domain, 
          :order_id=>params[:order_id],
          :shop_id=>@shop.id, 
          :order_number=> order.name,
          :total=>  order.total_price, 
          :email=>  order.email,
          :name=> "#{order.billing_address.first_name} #{order.billing_address.last_name}"
          )
      else
        redirect_to root_path, :notice=>'That order does not exist.'
      end
    else
      logger.debug("send_payment_information: No params sent or shop is nil #{@shop}")
      redirect_to root_path, :notice=>'No params sent or shop is nil'
    end

  end

  # manually creates 
  def create
    order   = nil

    if @shop && params[:invoice]
      @invoice = Invoice.new(params[:invoice])
      @invoice.create_invoicexpress()
      if @invoice.save
        #lets create by now
        #PayMailer.payment_information(@payment, @shop).deliver
        redirect_to root_path, :notice=>'Created invoice'
      else
        render :new, :notice=>'There were problems with the form, please fill the missing information.'
      end
    else
      render :new, :alert=>'No params sent or shop is nil'
    end
  end

  private
    def load_shop
      @shop    = Shop.where(:store_url=>ShopifyAPI::Shop.current.domain).first
    end

end
