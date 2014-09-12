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
                     user_id: u.id)


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

  end

end
