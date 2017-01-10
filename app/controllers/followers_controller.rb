class FollowersController < ApplicationController
  before_action :load_user
  before_action :logged_in_user

  def index
    @title = t ".followers"
    @users = @user.followers.paginate page: params[:page],
      per_page: Settings.follow_per_page
    render "shared/show_follow"
  end
end
