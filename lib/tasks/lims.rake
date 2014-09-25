
namespace :lims do
  desc "Populate database with default content"

  task populate: :environment do

    p = Product.create(name: 'ABI MGB assay', description: 'Applied BioSystems MGB assay')

    p.product_params.create(key: 'product_name', name: 'Assay ID', description: "e.g. Hs_01086177_m1",
                            paramtype: :string, constraint: '', mandatory: false, value: '')
    p.product_params.create(key: 'gene_name', name: 'Gene Name', description: "Name of targeted gene",
                            paramtype: :string, constraint: '', mandatory: false, value: '')
    p.product_params.create(key: 'species_name', name: 'Species', description: "Target organism",
                            paramtype: :string, constraint: '', mandatory: false, value: '')
    p.save!

    u = User.create(name: 'admin',
                    email: 'admin@admin.hu',
                    password: 'admin',
                    password_confirmation: 'admin',
                    admin: true)

    o = Order.create(order_date: '',
                     catalog_number: '',
                     price: 1234.0,
                     quantity: '1',
                     units: 'pack',
                     department: 'bio',
                     comment: 'need fast',
                     url: 'https://bioinfo.appliedbiosystems.com/genome-database/details/gene-expression/Mm00801462_m1',
                     ordered_from: 'ABi',
                     status: 0,
                     product: p,
                     user_id: u.id
                     )
    o.create_product_specific_params
    o.save!

    p = Product.create(name: 'Antibody', description: 'Antibody for a specific target')

    p.product_params.create(key: 'ab_application', name: 'Application', description: "Application",
                            paramtype: :string, constraint: '', mandatory: false, value: '')
    p.product_params.create(key: 'ab_prot_name', name: 'Protein Name', description: "Name of targeted protein",
                            paramtype: :string, constraint: '', mandatory: false, value: '')
    p.product_params.create(key: 'ab_producer', name: 'Producer', description: "Who produced this antibody",
                            paramtype: :string, constraint: '', mandatory: false, value: '')
    p.save!
    o = Order.create(order_date: '',
                     catalog_number: '',
                     price: 4.0,
                     quantity: '1',
                     units: 'pack',
                     department: 'bio',
                     comment: 'for experiment',
                     url: '',
                     ordered_from: 'ABi',
                     status: 0,
                     product: p,
                     user_id: u.id)
    o.create_product_specific_params
    o.save!
    
  end

  task create_admin: :environment do
    u = User.create(name: 'admin',
                    email: 'admin@admin.hu',
                    password: 'admin',
                    password_confirmation: 'admin',
                    admin: true)
  end

  def create_users(user_num = 40)
    0.upto(user_num) do |i|
      name = Faker::Internet.user_name
      email = Faker::Internet.email
      puts "creating #{name} #{email}"
      u = User.create(name: name, email: email, password: 'abc', password_confirmation: 'abc')
      if not u
        puts "failed"
      end
    end
  end

  def create_orders()
    products = Product.all
    users = User.all

    order_num = 300
    open_percent = 10
    units = ['5 pack', 'piece', '10 pack', '20 pack', '100 pack']
    departments = ['microbiology', 'it', 'sales', 'analytics']
    places = ['drawer', '-20', '-80', 'shelf']
    places.concat((1..10).collect {|i| "freezer #{i}"})
    places.concat((1..20).collect {|i| "at #{users[i].name}'s place" })

    0.upto(order_num) do |i|
      date1 = Faker::Date.backward(600)
      status = 1
      place = nil
      if rand(100)<open_percent
        status = 0
        date2 = nil
      else
        date2 = date1+((rand(336)+1)*60).minutes
        while date2 > DateTime.now
          date2 = date1+((rand(336)+1)*60).minutes
        end
        place = places[rand(places.size)]
      end
      puts "creating order #{i}"
      o = Order.create!(order_date: '',
            catalog_number: Faker::Code.ean,
            price: Faker::Commerce.price,
            place: place,
            quantity: rand(20)+1,
            units: units[rand(units.size)],
            department: departments[rand(departments.size)],
            comment: Faker::Commerce.product_name,
            url: Faker::Internet.url,
            ordered_from: Faker::Company.name,
            status: status,
            order_date: date1,
            arrival_date: date2,
            product: products[rand(products.size)],
            user_id: users[rand(users.size)].id
      )
    end
  end

  task populate_realistic: :environment do
    #create_users()
    create_orders()

    price = [50,75,100,2000,2300,5400,5700]

    quantity = [1,2,3,5,10,12]
    department = ['bio', 'it', 'sales']
    status = [0,1]
    y = [2012, 2013,2014]
    m = (1..9).to_a
    d = (1..22).to_a


      # for i in 0..200
      #   actualprice = price.sample
      #   actualunits = units.sample
      #   actualquantity = quantity.sample
      #   actualdepartment = department.sample
      #   actualstatus = status.sample
      #   year = y.sample
      #   month = m.sample
      #   day = d.sample
      #   orderdate = Date.new(year, month, day)
      #   if actualstatus == 1
      #     arriveddate = Date.new(year, month, day+3)
      #   else
      #     arriveddate = nil
      #   end
      #
      #   rand_id = rand(Product.count)
      #   if rand_id == 0
      #     rand_id += 1
      #   end
      #   actualproduct = Product.find(rand_id)
      #
      #   o = Order.create(order_date: '',
      #       catalog_number: '',
      #       price: actualprice,
      #       quantity: actualquantity,
      #       units: actualunits,
      #       department: actualdepartment,
      #       comment: '',
      #       url: '',
      #       ordered_from: '',
      #       status: actualstatus,
      #       order_date: orderdate,
      #       arrival_date: arriveddate,
      #       product: actualproduct,
      #       user_id: 1
      #   )
      #
      #   o.save!
      #
      #   @product_params = actualproduct.product_params
      #   @filtered_params = @product_params.select { |param| param.is_product == true }
      #   @filtered_params.each do |param|
      #     pp= ProductParam.create(order_id: o.id, product_id: actualproduct.id, key: param.key, name: param.name, is_product: false, description: param.description,
      #                                 paramtype: param.paramtype, constraint: param.constraint, mandatory: param.mandatory, value: param.value)
      #     pp.save!
      #   end
      # end
  end

end
