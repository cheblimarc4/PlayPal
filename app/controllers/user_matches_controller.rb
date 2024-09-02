class UserMatchesController < ApplicationController
  before_action :set_match, only: [:create]
  before_action :set_usermatch, only: [:acceptuser, :rejectuser, :cancel_match]

  def create
    if @match.UserMatches.accepted.length < @match.need
      if already_requested(@match)
        redirect_to match_path(@match), notice: "You already requested to join."
        return
      end
      @user_match = create_user_match(@match)
      if @user_match.save
        redirect_to match_path(@match), success: "Your request is sent to the owner!"
      else
        redirect_to match_path(@match), alert: "Sorry, something went wrong :("
      end
    else
      redirect_to match_path(@match), alert: "Sorry, the team is full!"
    end
  end



  def cancel_match
    if current_user == @usermatch.user
      @usermatch.destroy
      render json: { message: "Done" }
    end
  end

  def acceptuser
    update_user_request_status(@usermatch, "accept")
  end

  def rejectuser
    update_user_request_status(@usermatch, "reject")
  end

  private

  def update_user_request_status(usermatch, status)
    if current_user == usermatch.match.user
      if status == "accept" ? usermatch.accepted! : usermatch.denied!
        set_user_team(usermatch) if status == "accept"
        render json: { message: usermatch }
      else
        render json: { error: "Something went wrong!" }
      end
    else
      render json: { notice: "You are not authorized to do that,"}
    end
  end

  def set_user_team(usermatch)
    total_players = usermatch.match.sport.number_of_players.to_i # getting total players need in a sport
    players_needed = total_players - usermatch.match.need.to_i # gets players we need
    total_players_each_team = (total_players.to_f % 2).zero? ? total_players / 2 : [(total_players.to_f / 2).floor, (total_players.to_f / 2).ceil ] # if half of total players is even then it returns a number otherwise an array [lowernum, highernum]
    players_have = usermatch.match.need # player that already exists.
    each_team = (players_have.to_f % 2).zero? ? players_have / 2 : [(players_have.to_f / 2).floor, (players_have.to_f / 2).ceil ] # checks for existing matches
    team_a = (total_players_each_team.is_a?(Array) ? total_players_each_team[0] : total_players_each_team) - (each_team.is_a?(Array) ? each_team[0] : each_team)
    team_b = (total_players_each_team.is_a?(Array) ? total_players_each_team[1] : total_players_each_team) - (each_team.is_a?(Array) ? each_team[1] : each_team)
    current_team_a = usermatch.match.UserMatches.where(team: "teamA").count || 0
    current_team_b = usermatch.match.UserMatches.where(team: "teamB").count || 0
    team_a - current_team_a > team_b - current_team_b ? usermatch.teamA! : usermatch.teamB!
  end

  def set_usermatch
    @usermatch = UserMatch.find(params[:id])
  end

  def already_requested(match)
    exists = false
    match.UserMatches.each do |user_match|
      exists = true if user_match.user == current_user
    end
    return exists
  end

  def create_user_match(match)
    user_match = UserMatch.new
    user_match.match = match
    user_match.user = current_user
    return user_match
  end

  def set_match
    @match = Match.find(params[:match_id])
  end
end
