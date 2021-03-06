class UsersController < ApplicationController
  before_action :load_user, except: [:index, :new, :create]
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.per_page
  end

  def show
    @microposts = @user.feed.latest_order.paginate page: params[:page],
      per_page: Settings.posts_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = t ".check_email_message"
      redirect_to root_url
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
