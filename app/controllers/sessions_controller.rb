class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      redirect_to '/welcome'
    else
      render 'new'
    end
  end

  def welcome
  end
end
