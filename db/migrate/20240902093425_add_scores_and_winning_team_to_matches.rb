class AddScoresAndWinningTeamToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :team_a_score, :integer
    add_column :matches, :team_b_score, :integer
    add_column :matches, :winning_team, :integer
  end
end
