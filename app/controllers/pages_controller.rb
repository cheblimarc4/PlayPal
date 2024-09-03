class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @sports = Sport.all
  end
  def myprofile
    @user = current_user
    @user_matches = UserMatch.where(user: current_user)
    @matches = Match.where(user: current_user)
  end
end
