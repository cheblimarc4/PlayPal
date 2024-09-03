class ChangeUserRatingToDefault0 < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :rating, :integer, default: 1.5
  end
end
