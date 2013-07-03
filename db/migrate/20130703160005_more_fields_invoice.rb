class MoreFieldsInvoice < ActiveRecord::Migration
  def up
    add_column :invoices, :vat_number, :string
    add_column :invoices, :client_id, :integer
    add_column :invoices, :sent_email, :boolean, :default=>false
    add_column :shops, :vat_code_default, :string
    add_column :shops, :vat_code_inside_eu, :string
    add_column :shops, :vat_code_outside_eu, :string
  end

  def down
    remove_column :invoices, :vat_number
    remove_column :invoices, :client_id 
    remove_column :invoices, :sent_email 
    remove_column :shops, :vat_code_default 
    remove_column :shops, :vat_code_inside_eu 
    remove_column :shops, :vat_code_outside_eu 
  end
end
