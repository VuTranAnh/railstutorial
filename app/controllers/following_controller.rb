class FollowingController < ApplicationController
  before_action :load_user
  before_action :logged_in_user

  def index
    @title = t ".following"
    @users = @user.following.paginate page: params[:page],
      per_page: Settings.follow_per_page
    render "shared/show_follow"
  end
end
