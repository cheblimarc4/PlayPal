require "date"
class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :update_results, :match_ready]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @sports = Sport.all
    query = [params[:sport] || "", params[:level] || "", params[:time] || ""].join(' ').strip
    @matches = query.empty? ? Match.all : Match.search(query)
    @matches = @matches.where(match_date: Date.parse(params[:date])) if check_date_validity(params[:date])

    @mymatches = @matches.where(user: current_user)
    @othermatches = @matches.where.not(user: current_user)
  end

  def show
    @already_requested = already_requested?(@match)
    @markers =
      [{
        lat: @match.latitude,
        lng: @match.longitude
      }]
  end

  def match_ready
    players_we_have = @match.UserMatches.where(status: "accepted").count + @match.need
    enough_players =  players_we_have == @match.sport.number_of_players
    @match.ready = true if enough_players
    render json: { message: @match.save ? true : false }
  end

  def update_results
    if @match.user_id == current_user.id
      team_a_score = params[:team_a_score].to_i
      team_b_score = params[:team_b_score].to_i
      if @match.add_results(team_a_score, team_b_score)
        redirect_to @match, notice: "Match results added successfully."
      else
        redirect_to @match, alert: "Failed to add match results."
      end
    else
      redirect_to @match, alert: "You are not authorized to add results for this match."
    end
  end

  def mymatches
    @matches = Match.where(user: current_user)
    @user_requests = UserMatch.where(user: current_user)
  end

  def yourequest
    @user_requests = UserMatch.where(user: current_user)
  end

  def new
    @match = Match.new
  end

  def create
    @match = Match.new(match_params)
    @match.user = current_user
    if @match.save
      redirect_to matches_path, notice: 'Match was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def check_date_validity(test_date)
    return false if test_date.nil?

    Date.parse(test_date)
    true
    rescue ArgumentError
      false
  end

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:game_type, :level, :match_date, :location, :match_time, :need, :sport_id)
  end

  def already_requested?(match)
    exists = false
    match.UserMatches.each do |user_match|
      exists = true if user_match.user == current_user
    end
    return exists
  end
end
