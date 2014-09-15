require 'test_helper'

class PopulateControllerTest < ActionController::TestCase
  test "should get import" do
    get :import
    assert_response :success
  end

end
