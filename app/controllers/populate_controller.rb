class PopulateController < ApplicationController
  def index
  end

  def import
    begin
    require 'spreadsheet'
    uploaded_io = params[:xls]
    path = Rails.root.join('public', 'data', uploaded_io.original_filename)
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    workbook = Spreadsheet.open(path)
    parr = Array.new
    pparr = Array.new
    oarr = Array.new

    0.upto workbook.sheet_count-1 do |index|
      sheet = workbook.worksheet(index)
      sheet.each do |row|
        if sheet.name == 'products'
          prod = {"id" => row[0], "name" => row[1], "description" => row[2]}
          parr.push(prod)
        elsif sheet.name == 'product_params'
          pp = {"product_id" => row[0], "key" => row[1], "name" => row[2], "paramtype" => row[3], "description" => row[4], "constrinat" => row[5], "mandatory" => row[6], "value" => row[7]}
          pparr.push(pp)
        elsif sheet.name == 'orders'
          o = {"product_id" => row[0], "order_date" => row[1], "catalog_number" => row[2], "price" => row[3], "quantity" => row[4], "units" => row[5], "department" => row[6], "comment" => row[7], "url" => row[8], "ordered_from" => row[9], "status" => row[10], "arrival_date" => row[11], "place" => row[12], "user_id" => current_user.id}
          oarr.push(o)
        end
      end
    end

    pidhash = Hash.new
    parr.each do |item|
      if item['id'] != 'id'
        p = Product.create(name: item['name'], description: item['description'])
        spparr = pparr.select { |pp| pp["product_id"] == item['id'] }
        spparr.each do |item|
          if item['product_id'] != 'product_id'
            p.product_params.create(key: item['key'], name: item['name'], paramtype: item['paramtype'], description: item['description'], constraint: item['constraint'], mandatory: item['mandatory'], value: item['value'])
          end
        end
        p.save!
        pidhash[item['id']] = p.id
      end
    end

    oarr.each do |oitem|
      if oitem['product_id'] != 'product_id'
        dbid = pidhash[oitem['product_id']]
        pr = Product.find(dbid)
        o = Order.create(product: pr, order_date: oitem['order_date'], catalog_number: oitem['catalog_number'],
            price: oitem['price'], quantity: oitem['quantity'],
            units: oitem['units'], department: oitem['department'],
            comment: oitem['comment'], url: oitem['url'],
            ordered_from: oitem['ordered_from'], status: oitem['status'],
            arrival_date: oitem['arrival_date'], place: oitem['place'], user_id: current_user.id)
      end
    end

    redirect_to(:populate_index, notice: 'Import successful!')
    rescue => e
    redirect_to(:populate_index, alert: e.message)
    end
  end

  def export
    @products = Product.all
    @product_params = ProductParam.all
    @orders = Order.all
    require 'spreadsheet'
    respond_to do |format|
          format.pdf
          format.xls {
            wb = Spreadsheet::Workbook.new
            sheet1 = wb.create_worksheet :name => 'products'
            sheet1.row(0).concat %w{id name descripttion}
            @products.each_with_index { |product, i|
              sheet1.row(i+1).push product.id,product.name,product.description
            }
            sheet2 = wb.create_worksheet :name => 'product_params'
            sheet2.row(0).concat %w{product_id	key	name	paramtype	description	constraint	mandatory	value}
            j=0
            @product_params.each { |product_param|
              if product_param.is_product == true
                sheet2.row(j+1).push product_param.product_id, product_param.key, product_param.name, product_param.paramtype, product_param.description, product_param.constraint, product_param.mandatory, product_param.value
                j+=1
              end
            }
            sheet3 = wb.create_worksheet :name => 'orders'
            sheet3.row(0).concat %w{product_id	order_date	catalog_number	price	quantity	units	department	comment	url	ordered_from	status	arrival_date	place}
            @orders.each_with_index { |order, i|
              sheet3.row(i+1).push order.product_id, order.order_date, order.catalog_number, order.price, order.quantity, order.units, order.department, order.comment, order.url, order.ordered_from, order.status, order.arrival_date, order.place
            }
            data = StringIO.new('')
            wb.write data
            send_data data.string, :type=>"application/vnd.ms-excel", :disposition=>'attachment', :filename => 'limsexport.xls'
          }
      end
  end
end