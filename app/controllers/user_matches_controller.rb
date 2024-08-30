class UserMatchesController < ApplicationController
  before_action :set_match, only: [:create]
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
    @user_match = UserMatch.find(params[:id])
      if current_user == @user_match.match.user
        @user_match.destroy
        format.json {render json: { message: "You Successfully deleted your request"}}
      end
    end

  private

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
