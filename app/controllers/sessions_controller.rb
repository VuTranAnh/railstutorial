class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email]
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t ".invalid_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = t ".logout_success"
    redirect_to root_url
  end
end
