class Product < ActiveRecord::Base
  has_many :product_params, :dependent => :delete_all
  has_many :orders
  validates :name, presence: true,
            length: {minimum: 3}
end
