class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      @relation = current_user.active_relationships
        .find_by followed_id: @user.id
      response_to @user
    else
      flash[:info] = t ".user_notfound"
      redirect_to root_url
    end
  end

  def destroy
    relationship = Relationship.find_by(id: params[:id])
    if relationship
      @user = relationship.followed
      if @user
        current_user.unfollow @user
        @relation = current_user.active_relationships.build
        response_to @user
      end
    else
      flash[:info] = t ".relationship_notfound"
      redirect_to root_url
    end
  end

  private
  def response_to user
    respond_to do |format|
      format.html {redirect_to user}
      format.js
    end
  end
end
