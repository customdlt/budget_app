class SessionsController < ApplicationController
  skip_before_action  :authenticate , only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to user
    else
      flash.now[:error] = "Invalid username/password combination."
      render 'new', status: :unauthorized
    end
  end

  def welcome
  end

  def destroy
    log_out
    redirect_to root_url, flash: { info: 'You have  successfully logged out.' }
  end
end
