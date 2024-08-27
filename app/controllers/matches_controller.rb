class MatchesController < ApplicationController
  def index
    @matches = Match.all
    @sports = Sport.all
  end
  def show
    # authorize @match
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end
  def match_params
    params.require(:match).permit()
  end
end
