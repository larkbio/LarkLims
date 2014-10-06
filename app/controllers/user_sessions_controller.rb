class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]
  def new
    @user = User.new
  end

  def create
    @user = User.where(email: params[:email]).first
    if @user && @user.active
      if @user = login(params[:email], params[:password])
        redirect_back_or_to(controller: 'pages', action: 'dashboard', notice: 'Login successful')
      else
        flash.now[:alert] = 'Login failed'
        render action: 'new'
      end
    else
      @user = nil
      redirect_to login_path, alert: "Invalid or inactive user"
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: "Logged out!"
  end
end