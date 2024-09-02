class AddCoordinatesToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :latitude, :float
    add_column :matches, :longitude, :float
  end
end
