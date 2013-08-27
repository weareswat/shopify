class MoreFieldsShop < ActiveRecord::Migration
  def change
    add_column :shops, :store_id, :integer
    add_column :shops, :token, :string
  end
end