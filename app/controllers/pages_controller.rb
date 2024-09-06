class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @sports = Sport.all
  end

  def myprofile
    @um = UserMatch.where(user: current_user)
    @user_matches = @um.where(status: "accepted")
    @matches = @user_matches.map { |usermatch| usermatch.match }
    @total_wins, @total_losses, @total_matches = calculate_wins(@matches)
    @user = current_user
  end

  def calculate_wins(matches)
    losses = 0.0
    wins = 0.0
    total_matches = 0.0
    matches.each do |match|
      next if match.winning_team.nil?
      total_matches += 1.0

      winning_team = match.winning_team == 1.0 ? "teamA" : "teamB"
      usermatch = match.UserMatches.find_by(user: current_user)
      usermatch.team == winning_team ? wins += 1.0 : losses += 1.0
    end

    return wins, losses, total_matches
  end
end
