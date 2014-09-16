class Order < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :product_params
  validates :product, presence: true
  validates :user, presence: true


  def create_product_specific_params
    p "duplicate params called on:"
    p self

    self.product.product_params.each do |param|
      par = param.dup
      par.is_product = false
      self.product_params.append(par)
    end
   end
end
