class Addusernametousers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string, uniqueness: true

  end
end