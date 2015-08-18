class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :name
      t.string :country
      t.string :city
      t.string :state
      t.string :postal_code
      t.float :weight

      t.timestamps null: false
    end
  end
end
