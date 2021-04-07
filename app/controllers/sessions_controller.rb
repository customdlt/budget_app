class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to user
    else
      flash[:error] = "Invalid username/password combination."
      render 'new'
    end
  end

  def welcome
  end

  def destroy
    log_out
    redirect_to root_url, flash: { info: 'You have  successfully logged out.' }
  end
end
