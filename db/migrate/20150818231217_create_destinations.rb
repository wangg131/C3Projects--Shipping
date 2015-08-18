class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string :street
      t.string :city
      t.string :country
      t.string :state
      t.string :zip

      t.timestamps null: false
    end
  end
end
