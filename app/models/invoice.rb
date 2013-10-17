class Invoice < ActiveRecord::Base
  attr_accessible :day, :email, :invoice_id, :month, :name, :order_id, :shop_id, :store_url, :total, :year, :order_number

  validates_presence_of :shop_id, :store_url, :order_number, :invoice_id
  belongs_to :shop

  paginates_per 10

  #creates a invoice via invoicexpress
  def create_invoicexpress()
    status  = true
    begin
      @client = get_invoicexpress_client()
      order   = ShopifyAPI::Order.find(self.order_id)
      store   = ShopifyAPI::Shop.current
      date    = get_ix_date(order.created_at)
      state   = Invoicexpress::Models::InvoiceState.new(:state => "finalized")
      
      #items leave it like this for now for debugging issues
      items=[]
      line_items      = get_line_items(order, store.taxes_included)
      shipping_items  = get_shipping(order, store.taxes_included, store.tax_shipping)
      items           = line_items+shipping_items
      
      new_invoice = Invoicexpress::Models::Invoice.new(
        :date         => date,
        :due_date     => date,
        :reference    => order.name,
        :observations => order.note,
        :tax_exemption=> get_tax_exemption(order, store.tax_shipping),
        :client       => @client.client_by_code(order.customer.id)||get_client(order.customer, order.note_attributes),
        :items        => items
      )
      #debugger
      new_invoice     = @client.create_invoice(new_invoice)
      self.invoice_id = new_invoice.id
      self.year       = date.year
      self.month      = date.month
      self.day        = date.day

      #if should_finalize_invoice?(order, new_invoice)
      if shop.finalize_invoice==true
        #most probable cause: Date can not be before last sent invoice of this sequence
        @client.update_invoice_state(new_invoice.id, state)
      end
      
      #add_metafield(order)
    rescue Faraday::Error::ConnectionFailed => e
      logger.debug("ConnectionFailed with InvoiceXpress")
      status= "Connection Failed with the InvoiceXpress API. Please try again or contact support if the error persists."
    rescue Invoicexpress::UnprocessableEntity => e
      logger.debug("Error: UnprocessableEntity")
      status= e.response_body.errors.first
    rescue Invoicexpress::Unauthorized => e
      logger.debug("Error: Unauthorized")
      status= e.response_body
    rescue Invoicexpress::InternalServerError => e
      logger.debug("Error: InternalServerError")
      status= e.response_body
    rescue Invoicexpress::NotFound => e
      logger.debug("Error: NotFound")
      status= e.response_body
    rescue Faraday::Error::TimeoutError => e
      status= "There was a timeout connecting with the InvoiceXpress API. Please try again or contact support if the error persists."
    end  

    #return self.invoice_id
    return status
  end
  
  def send_email
    @client = get_invoicexpress_client()
    invoice       = nil
    
    if self.invoice_id
      invoice = @client.invoice(self.invoice_id)
      begin
        #before we send email, the invoice must be finalized.
        if invoice.status=="draft"
          state   = Invoicexpress::Models::InvoiceState.new(:state => "finalized")
          @client.update_invoice_state(self.invoice_id, state)
        end

        message = Invoicexpress::Models::Message.new(
          :client => invoice.client,
          :subject => "Invoice for order #{self.order_number}",
          :body => "Here's your invoice from the order #{self.order_number}. Thanks you for shopping with us. See you soon."
        )
        @client.invoice_email(self.invoice_id, message)
      rescue Invoicexpress::UnprocessableEntity => e
        return e.response_body.errors.first    
      end
      return true
    else
      return false
    end
  end
  
  # returns true or false if the invoice is valid for passing final state 
  def should_finalize_invoice?(order, invoicexpress_invoice)
    nif_is_valid  = false
     
    if invoicexpress_invoice.client && invoicexpress_invoice.client.fiscal_id
      nif_is_valid= validate_fiscal_id(invoicexpress_invoice.client.fiscal_id)
    # elsif order.note_attributes && order.note_attributes.size>0
    #   order.note_attributes.each do |attr|
    #     nif_is_valid= validate_fiscal_id(attr.value) if attr.name == "nif"
    #   end
    end
    nif_is_valid
  end


  private
    # what it says
    def check_account_authorized()
      authorized=false
      begin
        @client.accounts
        authorized=true
      rescue Invoicexpress::Unauthorized => e
        puts e.response_body 
      end
      authorized
    end

    # gets client for invoicexpress
    def get_invoicexpress_client()
      self.shop.get_invoicexpress_client()
    end

    # returns true if the fiscal_id is valid
    def validate_fiscal_id(fiscal_id)
      return Valvat.new(fiscal_id).valid?
    end

    # adds a metafield with the invoice id to the order
    def add_metafield(order)
      order.add_metafield(
        ShopifyAPI::Metafield.new({
           :description => "InvoiceXpress id",
           :namespace => 'invoicexpress',
           :key => "invoice_id",
           :value => self.invoice_id,
           :value_type => 'integer'
        })
      )
    end

    # returns an array with Invoicexpress::Models::Item for each line item
    def get_line_items(order, taxes_included=nil)
      items=[]
      if order.line_items != nil
        order.line_items.each do |line_item|
          new_item=Invoicexpress::Models::Item.new(
            :name => line_item.title,
            :description=> "SKU: #{line_item.sku}",
            :unit_price => get_price(line_item.price.to_f, taxes_included, order.tax_lines),
            :quantity => line_item.quantity,
            :unit => "unit"
          )
          if order.tax_lines!=nil && order.tax_lines.size>0 
            new_item.tax=get_tax(order.tax_lines.first.rate)
          end
          items << new_item
        end
      end
      items
    end

    # returns an array with Invoicexpress::Models::Item for each shipping item
    def get_shipping(order, taxes_included=false, tax_shipping=false)
      items=[]
      if order.shipping_lines != nil
        order.shipping_lines.each do |item|
          new_item=Invoicexpress::Models::Item.new(
            :name => item.title,
            :description=> item.code,
            :unit_price => item.price,
            :quantity => 1,
            :unit => "unit"
          )
          #should we calculate tax on shipping?
          if tax_shipping==true && order.tax_lines!=nil && order.tax_lines.size>0 
            new_item.unit_price=get_price(item.price.to_f, taxes_included, order.tax_lines)
            new_item.tax=get_tax(order.tax_lines.first.rate)
          end
          items << new_item
        end
      end
      items
    end

    # returns a Invoicexpress::Models::Tax model for the corresponding shopify tax
    def get_tax(tax_value)
      return nil if tax_value.nil? 
      tax_full = tax_value*100
      taxes    = @client.taxes
      ix_tax   = nil

      taxes.each do |tax|
        ix_tax=tax if tax.value==tax_full
      end
      
      if ix_tax.nil?
        model_tax = Invoicexpress::Models::Tax.new({
        :name        => "VAT#{tax_full.round}",
        :value       => tax_full,
        :region      => "Desconhecido",
        :default_tax => 0
        })
        ix_tax = @client.create_tax(model_tax)
      end

      return ix_tax
    end

    # retuns price for a item, if tax is included then formula for tax is Tax = (Tax Rate * Price) / (1 + Tax Rate)
    def get_price(price, taxes_included=false, tax_lines=[])
      if taxes_included==false
        return price
      else
        if tax_lines.size>0
          tax_rate=tax_lines.first.rate
        else
          tax_rate=0
        end
        tax=(tax_rate*price)/(1+tax_rate)
        return (price.round(2)-tax.round(2)).round(2)
      end
    end

    # gets tax_exemption if appliable
    def get_tax_exemption(order, tax_shipping)
      tax_exemption=nil
      if order.tax_lines==nil || order.tax_lines.empty?
        #tax exemption for normal cases
        tax_exemption="M08"
      elsif order.tax_lines!=nil && (tax_shipping==nil || tax_shipping==false)
        #tax exemption for shipping
        tax_exemption="M08"
      end
      tax_exemption
    end
    
    # gets date in invoicexpress format
    def get_ix_date(date)
      date=Date.parse date
      Date.new(date.year, date.month, date.day)
    end

    def get_client(customer, note_attributes=nil)
      if customer!=nil
        client= Invoicexpress::Models::Client.new(
          :name => "#{customer.first_name} #{customer.last_name}",
          :email=> customer.email,
          :code=> customer.id,
          :observations=>customer.note
        )
        #falta o fiscal_id
        if customer.default_address!=nil
          #client.country    = order.customer.default_address.country
          client.address    = "#{customer.default_address.address1}" #" #{customer.default_address.address2} #{customer.default_address.city}"
          if customer.default_address.address2
            client.address+=" #{customer.default_address.address2}"
          end
          if customer.default_address.city
            client.address+=" #{customer.default_address.city}"
          end
          client.postal_code= customer.default_address.zip
          client.phone      = customer.default_address.phone
        end

        if note_attributes && note_attributes.size>0
          note_attributes.each do |attr|
            if attr.name == "vat_number" 
              if Valvat.new(attr.value).valid?
                client.fiscal_id = Valvat::Utils.split(attr.value).last
                # client.fiscal_id = attr.value
              end
            end
          end
        end
        client
      else
        Invoicexpress::Models::Client.new(
          :name => "Shopify Anonimous Customer"
        )
      end
    end

end
