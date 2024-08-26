class CreateSports < ActiveRecord::Migration[7.1]
  def change
    create_table :sports do |t|
      t.string :name
      t.integer :number_of_players

      t.timestamps
    end
  end
end
