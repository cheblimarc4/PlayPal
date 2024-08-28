require "date"
class MatchesController < ApplicationController
  before_action :set_match, only: [:show]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @matches = Match.all
    @sports = Sport.all
  end

  def show
    @already_requested = already_requested?(@match)
  end

  def mymatches
    @matches = Match.where(user: current_user)
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end
  def match_params
    params.require(:match).permit()
  end

  def already_requested?(match)
    exists = false
    match.UserMatches.each do |user_match|
      exists = true if user_match.user == current_user
    end
    return exists
  end
end
