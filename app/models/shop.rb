class Shop < ActiveRecord::Base
  attr_accessible :email, :invoice_api, :invoice_user, :name, :store_url, :auto_send_email, :auto_sequence, :sequence_id, :vat_code_default, :vat_code_inside_eu, :vat_code_outside_eu

end
