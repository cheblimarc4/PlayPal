class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @sports = Sport.all
  end

  def myprofile
    @matches = current_user.matches.where(ready: true)
    @total_wins, @total_losses, @total_matches = calculate_wins(@matches)
    @user = current_user
    @user_matches = UserMatch.where(user: current_user)
  end

  def calculate_wins(matches)
    losses = 0.0
    wins = 0.0
    total_matches = 0.0
    matches.each do |match|
      total_matches += 1
      next if match.winning_team.nil?

      winning_team = match.winning_team == 1 ? "teamA" : "teamB"
      usermatch = match.UserMatches.find_by(user: current_user)
      usermatch.team == winning_team ? wins += 1 : losses += 1
    end

    return wins, losses, total_matches
  end
end
