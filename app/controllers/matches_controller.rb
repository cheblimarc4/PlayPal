require "date"
class MatchesController < ApplicationController
  before_action :set_match, only: [:show]
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
  def match_params
    params.require(:match).permit()
  end
end
