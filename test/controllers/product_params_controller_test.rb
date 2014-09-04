require 'test_helper'

class ProductParamsControllerTest < ActionController::TestCase
  setup do
    @product_param = product_params(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_params)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_param" do
    assert_difference('ProductParam.count') do
      post :create, product_param: { constraint: @product_param.constraint, description: @product_param.description, key: @product_param.key, mandatory: @product_param.mandatory, name: @product_param.name, paramtype: @product_param.paramtype, value: @product_param.value }
    end

    assert_redirected_to product_param_path(assigns(:product_param))
  end

  test "should show product_param" do
    get :show, id: @product_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_param
    assert_response :success
  end

  test "should update product_param" do
    patch :update, id: @product_param, product_param: { constraint: @product_param.constraint, description: @product_param.description, key: @product_param.key, mandatory: @product_param.mandatory, name: @product_param.name, paramtype: @product_param.paramtype, value: @product_param.value }
    assert_redirected_to product_param_path(assigns(:product_param))
  end

  test "should destroy product_param" do
    assert_difference('ProductParam.count', -1) do
      delete :destroy, id: @product_param
    end

    assert_redirected_to product_params_path
  end
end
