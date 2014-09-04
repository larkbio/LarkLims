class ProductParamsController < ApplicationController
  before_action :set_product_param, only: [:show, :edit, :update, :destroy]

  # GET /product_params
  # GET /product_params.json
  def index
    @product = Product.find(params[:product_id])
    @product_params = ProductParam.where(:product_id => params[:product_id])
  end

  # GET /product_params/1
  # GET /product_params/1.json
  def show
    @product = Product.find(params[:product_id])
    @product_param = ProductParam.find(params[:id])
  end

  # GET /product_params/new
  def new
    @product = Product.find(params[:product_id])
    @product_param = ProductParam.new
  end

  # GET /product_params/1/edit
  def edit
    @product = Product.find(params[:product_id])
    @product_param = ProductParam.find(params[:id])
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
    @product = Product.find(params[:product_id])
    respond_to do |format|
      if @product_param.update(product_param_params)
        format.html { redirect_to product_product_param_url(@product, @product_param), notice: 'Product param was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_param }
      else
        format.html { render :edit }
        format.json { render json: @product_param.errors, status: :unprocessable_entity }
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
