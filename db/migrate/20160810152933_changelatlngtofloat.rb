class Changelatlngtofloat < ActiveRecord::Migration[5.0]
  def change
    change_column :pois, :latitude, :float
    change_column :pois, :longitude, :float
  end
end
