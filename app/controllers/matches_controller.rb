require "date"
class MatchesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @matches = Match.all
    @sports = Sport.all
  end
  def show
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end
end
