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

  task populateorders: :environment do
      price = [50,75,100,2000,2300,5400,5700]
      units = ['pack', 'piece']
      quantity = [1,2,3,5,10,12]
      department = ['bio', 'it', 'sales']
      status = [0,1]
      y = [2012, 2013,2014]
      m = (1..9).to_a
      d = (1..22).to_a


      for i in 0..200
        actualprice = price.sample
        actualunits = units.sample
        actualquantity = quantity.sample
        actualdepartment = department.sample
        actualstatus = status.sample
        year = y.sample
        month = m.sample
        day = d.sample
        orderdate = Date.new(year, month, day)
        if actualstatus == 1
          arriveddate = Date.new(year, month, day+3)
        else
          arriveddate = nil
        end

        rand_id = rand(Product.count)
        if rand_id == 0
          rand_id += 1
        end
        actualproduct = Product.find(rand_id)

        o = Order.create(order_date: '',
            catalog_number: '',
            price: actualprice,
            quantity: actualquantity,
            units: actualunits,
            department: actualdepartment,
            comment: '',
            url: '',
            ordered_from: '',
            status: actualstatus,
            order_date: orderdate,
            arrival_date: arriveddate,
            product: actualproduct,
            user_id: 1
        )

        o.save!

        @product_params = actualproduct.product_params
        @filtered_params = @product_params.select { |param| param.is_product == true }
        @filtered_params.each do |param|
          pp= ProductParam.create(order_id: o.id, product_id: actualproduct.id, key: param.key, name: param.name, is_product: false, description: param.description,
                                      paramtype: param.paramtype, constraint: param.constraint, mandatory: param.mandatory, value: param.value)
          pp.save!
        end
      end
  end

end
