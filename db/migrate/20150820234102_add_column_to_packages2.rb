class AddColumnToPackages2 < ActiveRecord::Migration
  def change
    add_column :packages, :price, :float
    add_column :packages, :service_type, :string
  end
end
