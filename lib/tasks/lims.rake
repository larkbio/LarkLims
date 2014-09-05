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
                     product: p)

  end

end
