module ApplicationHelper

  def mActive(first, last="")
    if first==last
      'selected'
    end
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
