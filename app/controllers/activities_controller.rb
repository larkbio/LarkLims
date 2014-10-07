class ActivitiesController < ApplicationController
  include ActionView::Helpers::DateHelper
  def index
    lim = params[:limit].to_i
    before_date = params[:before_date]
    after_order_id = params[:before_order_id]

    create_activities = get_create_activities(lim, before_date, after_order_id)
    arrive_activities = get_arrive_activities(lim, before_date, after_order_id)

    activities = create_activities + arrive_activities

    # descending by date, ascending by order_id
    @activity_arr = activities.sort { |a,b| (a[:date].to_i == b[:date].to_i) ? ( a[:order_id] <=> b[:order_id] ) : ( b[:date].to_i <=> a[:date].to_i ) }

    if limit_ok?(lim)
      @activity_arr = @activity_arr[0..lim]
    end

    respond_to do |format|
      format.html { render :index }
      format.json {render json: @activity_arr}
    end

  end

  private

  def limit_ok?(limit)
    return (limit>0 and limit<1000)
  end

  def get_date(date_str)
    if date_str
      return DateTime.parse(date_str)
    else
      return nil
    end
  end

  def get_create_activities(lim, before_date, after_order_id)
    if before_date
      if after_order_id
        before1 = DateTime.parse(before_date)-1.second
        before2 = DateTime.parse(before_date)+1.second
        orders_query = Order.where("( (order_date between '#{before1.to_s}'  and '#{before2.to_s}' ) and id < #{after_order_id} ) or ( order_date <  '#{before_date}' )")
      else
        orders_query = Order.where("order_date <  \"#{before_date}\"")
      end
    else
      orders_query = Order.all
    end

    if limit_ok?(lim)
      orders_query = orders_query.order('order_date DESC, id ASC').limit(lim)
    else
      orders_query = orders_query.order('order_date DESC, id ASC')
    end

    result = []
    orders_query.each do |o|
      usr = user_path(o.user)
      opath = order_url(o)
      url_short = o.url
      if o.url and o.url.size>60
        url_short = o.url[0..60]+"..."
      end
      title = "<a href=\"/pages/browser?user_filter=#{o.user.id}\">#{o.user.name}</a>\n<span>added order</span>\n<a href=\"/pages/browser?order_selected=#{o.id}\">#{o.comment}</a> (#{o.product.name})\n"
      detail = "From: #{o.ordered_from} <a href=\"#{o.url}\" target=\"_blank\">#{url_short}</a>"
      result.append({:date => o.order_date ,:timediff => time_ago_in_words( o.order_date),
                         :activity_title => title, :activity_detail => detail,
                         :activity_icon => "fa-plus", :order_id => o.id,
                         :status => 0})
    end
    return(result)
  end

  def get_arrive_activities(lim, before_date, after_order_id)
    if before_date
      before1 = DateTime.parse(before_date)-1.second
      before2 = DateTime.parse(before_date)+1.second
      if after_order_id
        completed_query = Order.where("( (arrival_date between '#{before1.to_s}' and '#{before2.to_s}' ) and id < #{after_order_id} ) or ( arrival_date <  '#{before_date}' )")
      else
        completed_query = Order.where("arrival_date <  '#{before_date}'")
      end
    else
      completed_query = Order.all
    end

    completed_query = completed_query.where("status = 1")
    if limit_ok?(lim)
      completed_query = completed_query.order('arrival_date DESC, id ASC').limit(lim)
    else
      completed_query = completed_query.order('arrival_date DESC, id ASC').all
    end
    result = []
    completed_query.each do |o|
      detail = "Cat: #{o.catalog_number}, Place: #{o.place}"
      opath = order_url(o)
      title = "<span>order</span>\n<a href=\"/pages/browser?order_selected=#{o.id}\">#{o.comment}</a> (#{o.product.name})\n<span>arrived</span>\n"
      result.append({:date => o.arrival_date ,:timediff => time_ago_in_words( o.arrival_date),
                         :activity_title => title, :activity_detail => detail,
                         :activity_icon => "fa-check", :order_id => o.id,
                         :status => 1})
    end
    return(result)
  end

end
