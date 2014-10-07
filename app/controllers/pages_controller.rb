class PagesController < ApplicationController
  def dashboard
  end

  def browser
    uid = params[:user_filter].to_i
    u = User.find_by_id(uid)
    @user_filter = ""
    if u
      @user_filter= u.id
    end

    @order_selected = ""
    oid = params[:order_selected].to_i
    o = Order.find_by_id(oid)
    if o
      @order_selected = o.id
    end

  end

  def import
  end
end
