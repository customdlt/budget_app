class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :authenticate

  private

  def authenticate
    if current_user.nil?
      flash[:error] = "Please log in to view this page."
      redirect_to login_path
    end
  end
end
