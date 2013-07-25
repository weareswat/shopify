class Webhook < ActiveRecord::Base
  attr_accessible :invoice_id, :order_id, :params, :security, :shop_url, :shop_id
end
