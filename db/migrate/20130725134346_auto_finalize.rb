class AutoFinalize < ActiveRecord::Migration
  def change
  	add_column :shops, :finalize_invoice, :boolean, :default=>true
  end
end
