class AddMatchTimeToMatch < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :match_time, :string
  end
end
