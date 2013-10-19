class Country < ActiveRecord::Migration
  def change
      add_column :shops, "country", :string
  end
end
