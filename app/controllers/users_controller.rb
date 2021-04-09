class UsersController < ApplicationController
  before_action :authenticate, only: [:show]
  before_action :correct_user?,  only: [:show]
  before_action :logged_in_user?,  only: [:new]

  def new
    @user = User.new
    @user.build_budget
  end

  def create
    @user = User.new(user_params)
    if @user.save
      payload = { user_id: @user.id }
      log_in(@user)
      redirect_to @user
    else
      flash[:message] =  @user.errors.full_messages[0]
      render 'new'
    end
  end

  def show
    set_user
  end

  private

  # make sure correct user is viewing the page
  def correct_user?
    set_user
    unless current_user?(@user)
      redirect_to user_path(current_user)
    end
  end

  # make sure logged in user can't view sign up page
  def logged_in_user?
    if logged_in?
      redirect_to user_path(current_user)
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    # params.fetch(:user, {})
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :salt, :encrypted_password, budget_attributes: [:amount])
  end
end
