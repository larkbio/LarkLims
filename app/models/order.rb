class Order < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :product_params
  validates :product, presence: true
  validates :user, presence: true

  after_validation :create_product_specific_params

  protected

  def create_product_specific_params
    p "cb called on:"
    p self
    self.product.product_params.each do |param|
      par = param.dup
      self.product_params.append(par)
    end
  end
end
