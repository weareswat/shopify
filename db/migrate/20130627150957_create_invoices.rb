class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :order_id
      t.integer :shop_id
      t.string :store_url
      t.string :order_number
      t.string :total
      t.string :email
      t.string :name
      t.integer :invoice_id
      t.integer :day
      t.integer :month
      t.integer :year
      t.timestamps
    end
  end
end
