class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.text :params
      t.string :security
      t.string :shop_url
      t.integer :order_id
      t.integer :invoice_id
      t.timestamps
    end
  end
end
