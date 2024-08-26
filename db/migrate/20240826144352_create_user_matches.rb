class CreateUserMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :user_matches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.integer :status
      t.integer :team

      t.timestamps
    end
  end
end
