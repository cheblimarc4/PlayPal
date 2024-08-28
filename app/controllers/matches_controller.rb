require "date"
class MatchesController < ApplicationController
  before_action :set_match, only: [:show]
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
