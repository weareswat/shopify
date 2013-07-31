class ChangeAutoSendEmail < ActiveRecord::Migration
  def change
  	change_column :shops, :auto_send_email, :boolean, :default=>false
  end
end