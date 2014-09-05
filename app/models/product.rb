class Product < ActiveRecord::Base
  has_many :product_params
  has_many :orders
  validates :name, presence: true,
            length: {minimum: 5}
end
