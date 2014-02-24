module ApplicationHelper

  def customer_name_helper(order)
    if order.respond_to?(:customer)
      "#{order.customer.first_name} #{order.customer.last_name}"
    else
      "No customer name"
    end
  end

  def mActive(first, last="")
    if first==last
      'selected'
    end
  end

  def invoiceStatus(state)
    status=""
    if state  == 'final'
      status="label-success"
    end
    if state  == 'draft'
      status="label-warning"
    end

    status
  end

  def paymentStatus(order)
    status=""
    if order.status  == 'payed'
      status="label-success"
    end
    if order.status  == 'created'
      status="label-warning"
    end

    status
  end

  def orderStatus(order)
    status=""
    if order.financial_status  == 'paid'
      status="label-success"
    end
    if order.financial_status  == 'pending'
      status="label-warning"
    end
    if order.financial_status  == 'refunded'
      status="label-important"
    end
    status
  end

  # fetch from metafields
  # deprecated: never used
  #def orderInvoiceId(order)
  #  id=nil
  #  order.metafields.each do |meta|
  #    id=meta.value if meta.key=="invoice_id" && meta.namespace=="invoicexpress"
  #  end
  #  id
  #end

  def orderFulfilmentStatus(order)
    status=""
    if !order.fulfillment_status
      status="label-warning"
    else
      status="label-success"
    end
    status
  end

  def orderFulfilmentLabel(order)
    status=""
    if !order.fulfillment_status
      status="No"
    else
      status="Yes"
    end
    status
  end
end
