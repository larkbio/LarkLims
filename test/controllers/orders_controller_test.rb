require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: { arrival_date: @order.arrival_date, catalog_number: @order.catalog_number, comment: @order.comment, department: @order.department, order_date: @order.order_date, ordered_from: @order.ordered_from, place: @order.place, price: @order.price, quantity: @order.quantity, status: @order.status, units: @order.units, url: @order.url }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { arrival_date: @order.arrival_date, catalog_number: @order.catalog_number, comment: @order.comment, department: @order.department, order_date: @order.order_date, ordered_from: @order.ordered_from, place: @order.place, price: @order.price, quantity: @order.quantity, status: @order.status, units: @order.units, url: @order.url }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
end
