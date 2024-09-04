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
    @messages = @match.messages
    @message = Message.new
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
    @sorted_team = sort_team(@matches.first)
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

  def match_ready
    players_we_have = @match.UserMatches.where(status: "accepted").count + @match.need
    enough_players =  players_we_have == @match.sport.number_of_players
    @match.ready = true if enough_players
    render json: { message: @match.save ? true : false }
  end



  private

  def sort_team(match)
    team_a = match.UserMatches.where(team: "teamA")
    team_b = match.UserMatches.where(team: "teamB")
    players_have = match.need
    return true if team_a.count + team_b.count + players_have == match.sport.number_of_players

    have = players_have.even? ? players_have / 2 : [(players_have.to_f / 2).floor, (players_have.to_f / 2).ceil]
    if have.is_a?(Integer)
      sorted_team = [have, have]
    else
      if team_a.count > team_b.count
        sorted_team = [have[0], have[1]]
      elsif team_b.count > team_a.count
        sorted_team = [have[1], have[0]]
      else
        a = have.sample
        have.delete(a)
        sorted_team = [a, have[0]]
      end
    end
    return sorted_team
  end

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
