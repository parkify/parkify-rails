require 'test_helper'

class CapacityIntervalsControllerTest < ActionController::TestCase
  setup do
    @capacity_interval = capacity_intervals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:capacity_intervals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create capacity_interval" do
    assert_difference('CapacityInterval.count') do
      post :create, capacity_interval: {  }
    end

    assert_redirected_to capacity_interval_path(assigns(:capacity_interval))
  end

  test "should show capacity_interval" do
    get :show, id: @capacity_interval
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @capacity_interval
    assert_response :success
  end

  test "should update capacity_interval" do
    put :update, id: @capacity_interval, capacity_interval: {  }
    assert_redirected_to capacity_interval_path(assigns(:capacity_interval))
  end

  test "should destroy capacity_interval" do
    assert_difference('CapacityInterval.count', -1) do
      delete :destroy, id: @capacity_interval
    end

    assert_redirected_to capacity_intervals_path
  end
end
