class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login
  before_action :set_user_data
  private
  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
  def set_user_data
    if logged_in?
      @user = User.find(current_user.id)
    end
  end
end
