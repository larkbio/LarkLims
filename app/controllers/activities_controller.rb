class ActivitiesController < ApplicationController
  include ActionView::Helpers::DateHelper
  def index
    activities =  []

    Order.all.each do |o|
      usr = user_path(o.user)
      opath = order_url(o)
      title = "<a href=\"#{usr}\">#{o.user.name}</a>\n<span>added order</span>\n<a href=\"#{opath}\">#{o.product.name}</a>\n"
      activities.append({:date => o.created_at ,:timediff => time_ago_in_words( o.created_at),
                         :activity_title => title, :activity_detail => o.comment, :activity_icon => "fa-plus"})
    end

    Order.where("status = 1").each do |o|
        opath = order_url(o)
        title = "<span>order</span>\n<a href=\"#{opath}\">#{o.product.name}</a>\n<span>arrived</span>\n"
        activities.append({:date => o.arrival_date ,:timediff => time_ago_in_words( o.arrival_date),
                       :activity_title => title, :activity_detail => o.comment, :activity_icon => "fa-check"})
    end

    activities.sort_by { |item| item[:date] }
    activities.reverse

    render json: activities
  end
end
