class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]
  before_action :logged_in_user, except: [:new, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.per_page
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome_message"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
      redirect_to users_url
    else
      flash.now[:info] = t ".cannot_delete"
      render :index
    end
  end

  private
    def user_params
      params.require(:user).permit :name, :email, :password,
        :password_confirmation
    end

    def set_user
      @user = User.find_by id: params[:id]
      unless @user
        flash[:danger] = t ".page_notfound"
        redirect_to root_path
      end
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t ".please_log_in"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find_by id: params[:id]
      unless @user == current_user
        flash[:info] = t ".not_the_right_user"
        redirect_to root_url
      end
    end

    def admin_user
      unless current_user.admin?
        flash[:info] = t ".must_be_admin"
        redirect_to root_url
      end
    end
end
