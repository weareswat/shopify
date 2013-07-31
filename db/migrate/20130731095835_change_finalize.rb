class ChangeFinalize < ActiveRecord::Migration
  def change
  	change_column :shops, :finalize_invoice, :boolean, :default=>false
  end
end
