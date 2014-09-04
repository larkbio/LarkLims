class Product < ActiveRecord::Base
  has_many :product_params
  validates :name, presence: true,
            length: {minimum: 5}
end
