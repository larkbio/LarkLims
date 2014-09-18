class ProductParamsController < ApplicationController
  before_action :set_product_param, only: [:show, :edit, :update, :destroy]

  # GET /product_params
  # GET /product_params.json
  def index
    @is_product = false
    if params[:product_id]
      @product = Product.find(params[:product_id])
      @product_params = ProductParam.where(:product_id => params[:product_id])
      @is_product = true
    else
      @order = Order.find(params[:order_id])
      @product_params = ProductParam.where(:order_id => params[:order_id])
    end
  end

  # GET /product_params/1
  # GET /product_params/1.json
  def show
    @is_product = false
    if params[:product_id]
      @product = Product.find(params[:product_id])
      @product_param = ProductParam.find(params[:id])
      @is_product = true
    else
      @order = Order.find(params[:order_id])
      @product_param = ProductParam.find(params[:id])
    end
  end

  # GET /product_params/new
  def new
    @is_product = false
    if params[:product_id]
      @is_product = true

      @product = Product.find(params[:product_id])
      @product_param = ProductParam.new
    else
      render 'error', :status => 403
    end
  end

  # GET /product_params/1/edit
  def edit
    @is_product = false
    if params[:product_id]
      @product = Product.find(params[:product_id])
      @product_param = ProductParam.find(params[:id])
      @is_product = true
    else
      @order = Order.find(params[:order_id])
      @product_param = ProductParam.find(params[:id])
    end
  end

  # POST /product_params
  # POST /product_params.json
  def create
    @product = Product.find(params[:product_id])
    @product_param  = @product.product_params.create(product_param_params)
    # = ProductParam.new(product_param_params)

    respond_to do |format|
      if @product_param.save
        format.html { redirect_to product_product_param_url(@product, @product_param), notice: 'Product param was successfully created.' }
        format.json { render :show, status: :created, location: @product_param }
      else
        format.html { render :new }
        format.json { render json: @product_param.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_params/1
  # PATCH/PUT /product_params/1.json
  def update
    @is_product = false
    if params[:product_id]
      @is_product = true
      @product = Product.find(params[:product_id])
    else
      @order = Order.find(params[:order_id])
    end
    respond_to do |format|
      if @is_product
        if @product_param.update(product_param_params)
          format.html { redirect_to product_product_param_url(@product, @product_param), notice: 'Product param was successfully updated.' }
          format.json { render :show, status: :ok, location: product_product_param_path(@product, @product_param) }
        else
          format.html { render :edit }
          format.json { render json: @product_param.errors, status: :unprocessable_entity }
        end
      else
        if @product_param.update(product_param_params)
          format.html { redirect_to order_product_param_url(@order, @product_param), notice: 'Product param was successfully updated.'}
          format.json { render :show, status: :ok, location: order_product_param_path(@order, @product_param) }
        else
          format.html { render :edit }
          format.json { render json: @product_param.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /product_params/1
  # DELETE /product_params/1.json
  def destroy
    @product = Product.find(params[:product_id])
    @product_param.destroy
    respond_to do |format|
      format.html { redirect_to product_product_params_url(@product), notice: 'Product param was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_param
      @product_param = ProductParam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_param_params
      params.require(:product_param).permit(:key, :name, :paramtype, :description, :constraint, :mandatory, :value)
    end
end
