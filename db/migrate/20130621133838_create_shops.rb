class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.string :store_url
      t.string :email
      t.string :invoice_user
      t.string :invoice_api
      t.boolean :auto_send_email, :default=>1
      t.boolean :auto_sequence, :default=>0
      t.string :sequence_id
      t.timestamps
    end
  end
end
