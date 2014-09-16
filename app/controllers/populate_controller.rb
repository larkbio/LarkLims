class PopulateController < ApplicationController
  def index
  end

  def import
    ActiveRecord::Base.transaction do
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
      oparr = Array.new
      oarr = Array.new

      0.upto workbook.sheet_count-1 do |index|
        sheet = workbook.worksheet(index)
        sheet.each do |row|
          if sheet.name == 'products'
            prod = {"id" => row[0], "name" => row[1], "description" => row[2]}
            parr.push(prod)
          elsif sheet.name == 'product_params'
            pp = {"product_id" => row[0], "key" => row[2], "name" => row[3], "paramtype" => row[4], "description" => row[5], "constrinat" => row[6], "mandatory" => row[7], "value" => row[8]}
            pparr.push(pp)
          elsif sheet.name == 'order_params'
            op = {"product_id" => row[0], "order_id" => row[1], "key" => row[2], "name" => row[3], "paramtype" => row[4], "description" => row[5], "constrinat" => row[6], "mandatory" => row[7], "value" => row[8]}
            oparr.push(op)
          elsif sheet.name == 'orders'
            o = {"id" => row[0], "product_id" => row[1], "order_date" => row[2], "catalog_number" => row[3], "price" => row[4], "quantity" => row[5], "units" => row[6], "department" => row[7], "comment" => row[8], "url" => row[9], "ordered_from" => row[10], "status" => row[11], "arrival_date" => row[12], "place" => row[13], "user_id" => current_user.id}
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
                p.product_params.create(key: item['key'], name: item['name'], is_product: true, paramtype: item['paramtype'], description: item['description'], constraint: item['constraint'], mandatory: item['mandatory'], value: item['value'])
            end
          end
          p.save!
          pidhash[item['id']] = p.id
          puts 'pid'
          puts p.id
        end
      end


    puts
    oarr.each do |oitem|
      if oitem['product_id'] != 'product_id'
         dbid = pidhash[oitem['product_id']]
         puts 'dbid'
         puts dbid
         pr = Product.find(dbid)

        o = Order.create(product: pr, order_date: oitem['order_date'], catalog_number: oitem['catalog_number'],
            price: oitem['price'], quantity: oitem['quantity'],
            units: oitem['units'], department: oitem['department'],
            comment: oitem['comment'], url: oitem['url'],
            ordered_from: oitem['ordered_from'], status: oitem['status'],
            arrival_date: oitem['arrival_date'], place: oitem['place'], user_id: current_user.id)

        filteredoparr = oparr.select { |op| op["order_id"] == oitem['id'] }
         puts 'filteredoparr'
         puts filteredoparr
         filteredoparr.each do |item|
          if item['product_id'] != 'product_id'
            o.product_params.create(product_id: pr.id, key: item['key'], name: item['name'], is_product: false, paramtype: item['paramtype'], description: item['description'], constraint: item['constraint'], mandatory: item['mandatory'], value: item['value'])
          end
        end

        o.save!
      end
     end

      redirect_to(:populate_index, notice: 'Import successful!')
      rescue => e
        puts e.full_message
        redirect_to(:populate_index, alert: e.message)
      end

    end
  end

  def export
    @products = Product.all
    @product_params = ProductParam.where(is_product: true)
    @order_params = ProductParam.where(is_product: false)
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
            sheet2.row(0).concat %w{product_id order_id	key	name	paramtype	description	constraint	mandatory	value}
            j=0
            @product_params.each { |product_param|
                sheet2.row(j+1).push product_param.product_id, product_param.order_id, product_param.key, product_param.name, product_param.paramtype, product_param.description, product_param.constraint, product_param.mandatory, product_param.value
                j+=1
            }
            sheet3 = wb.create_worksheet :name => 'order_params'
            sheet3.row(0).concat %w{product_id order_id	key	name	paramtype	description	constraint	mandatory	value}
            j=0
            @order_params.each { |order_param|
                sheet3.row(j+1).push order_param.product_id, order_param.order_id, order_param.key, order_param.name, order_param.paramtype, order_param.description, order_param.constraint, order_param.mandatory, order_param.value
                j+=1
            }

            sheet4 = wb.create_worksheet :name => 'orders'
            sheet4.row(0).concat %w{id product_id	order_date	catalog_number	price	quantity	units	department	comment	url	ordered_from	status	arrival_date	place}
            @orders.each_with_index { |order, i|
              sheet4.row(i+1).push order.id, order.product_id, order.order_date.to_date, order.catalog_number, order.price, order.quantity, order.units, order.department, order.comment, order.url, order.ordered_from, order.status, order.arrival_date, order.place
            }
            data = StringIO.new('')
            wb.write data
            send_data data.string, :type=>"application/vnd.ms-excel", :disposition=>'attachment', :filename => 'limsexport.xls'
          }
      end
  end
end