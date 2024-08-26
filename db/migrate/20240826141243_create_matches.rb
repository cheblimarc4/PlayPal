class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sport, null: false, foreign_key: true
      t.string :game_type
      t.string :level
      t.boolean :ready
      t.date :match_date
      t.string :location

      t.timestamps
    end
  end
end
