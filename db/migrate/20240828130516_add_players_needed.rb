class AddPlayersNeeded < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :need, :integer
  end
end
