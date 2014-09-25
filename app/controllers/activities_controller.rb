class ActivitiesController < ApplicationController
  include ActionView::Helpers::DateHelper
  def index
    activities =  []

    Order.all.each do |o|
      usr = user_path(o.user)
      opath = order_url(o)
      url_short = o.url
      if o.url.size>60
        url_short = o.url[0..60]+"..."
      end
      title = "<a href=\"#{usr}\">#{o.user.name}</a>\n<span>added order</span>\n<a href=\"#{opath}\">#{o.comment}</a> (#{o.product.name})\n"
      detail = "From: #{o.ordered_from} <a href=\"#{o.url}\">#{url_short}</a>"
      activities.append({:date => o.order_date ,:timediff => time_ago_in_words( o.order_date),
                         :activity_title => title, :activity_detail => detail, :activity_icon => "fa-plus"})
    end

    Order.where("status = 1").each do |o|
        detail = "Cat: #{o.catalog_number}, Place: #{o.place}"
        opath = order_url(o)
        title = "<span>order</span>\n<a href=\"#{opath}\">#{o.comment}</a> (#{o.product.name})\n<span>arrived</span>\n"
        activities.append({:date => o.arrival_date ,:timediff => time_ago_in_words( o.arrival_date),
                       :activity_title => title, :activity_detail => detail, :activity_icon => "fa-check"})
    end


    a_sort = activities.sort_by { |item| item[:date].to_i }
    a_sort_rev = a_sort.reverse

    a_sort_rev.each {|i| puts "#{i[:date]} - #{i[:timediff]}"}
    render json: a_sort_rev
  end
end
