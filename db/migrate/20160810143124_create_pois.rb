class CreatePois < ActiveRecord::Migration[5.0]
  def change
    create_table :pois do |t|
      t.integer :latitude
      t.integer :longitude
      t.string :address

      t.timestamps
    end
  end
end
