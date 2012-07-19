require 'test_helper'

class CapacityListsControllerTest < ActionController::TestCase
  setup do
    @capacity_list = capacity_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:capacity_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create capacity_list" do
    assert_difference('CapacityList.count') do
      post :create, capacity_list: {  }
    end

    assert_redirected_to capacity_list_path(assigns(:capacity_list))
  end

  test "should show capacity_list" do
    get :show, id: @capacity_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @capacity_list
    assert_response :success
  end

  test "should update capacity_list" do
    put :update, id: @capacity_list, capacity_list: {  }
    assert_redirected_to capacity_list_path(assigns(:capacity_list))
  end

  test "should destroy capacity_list" do
    assert_difference('CapacityList.count', -1) do
      delete :destroy, id: @capacity_list
    end

    assert_redirected_to capacity_lists_path
  end
end
