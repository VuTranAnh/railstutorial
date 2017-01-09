class PasswordResetsController < ApplicationController
  before_action :get_valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_reset_email
      flash[:info] = t ".reset_email_message"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_notfound"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".cant_empty")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t ".password_has_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def get_valid_user
    @user = User.find_by email: params[:email]
    unless @user && @user.activated? &&
      @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t ".password_expired"
      redirect_to new_password_reset_url
    end
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
