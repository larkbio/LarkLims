class Order < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :product_params, :dependent => :delete_all
  validates :product, presence: true
  validates :user, presence: true
  before_save :default_values

  self.per_page = 20

  def create_product_specific_params
    p "duplicate params called on:"
    p self

    self.product.product_params.each do |param|
      par = param.dup
      par.is_product = false
      par.product_id = nil
      self.product_params.append(par)
    end
  end

  def default_values
    self.order_date ||= DateTime.now
    self.status ||= 0
  end
end
