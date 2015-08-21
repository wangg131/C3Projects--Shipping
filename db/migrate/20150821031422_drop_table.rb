class DropTable < ActiveRecord::Migration
  def change
    drop_table :shipments
    drop_table :destinations
  end
end
