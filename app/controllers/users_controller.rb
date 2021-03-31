class UsersController < ApplicationController
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
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

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
