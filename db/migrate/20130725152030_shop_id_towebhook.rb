class ShopIdTowebhook < ActiveRecord::Migration
  def change
  	add_column :webhooks, :shop_id, :integer
  end
end
