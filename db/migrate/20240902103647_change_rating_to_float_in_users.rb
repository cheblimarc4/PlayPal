class ChangeRatingToFloatInUsers < ActiveRecord::Migration[7.1]
  def change
    #change rating to float
    change_column :users, :rating, :float
  end
end
