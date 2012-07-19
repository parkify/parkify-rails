require 'test_helper'

class PricePlansControllerTest < ActionController::TestCase
  setup do
    @price_plan = price_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:price_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create price_plan" do
    assert_difference('PricePlan.count') do
      post :create, price_plan: {  }
    end

    assert_redirected_to price_plan_path(assigns(:price_plan))
  end

  test "should show price_plan" do
    get :show, id: @price_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @price_plan
    assert_response :success
  end

  test "should update price_plan" do
    put :update, id: @price_plan, price_plan: {  }
    assert_redirected_to price_plan_path(assigns(:price_plan))
  end

  test "should destroy price_plan" do
    assert_difference('PricePlan.count', -1) do
      delete :destroy, id: @price_plan
    end

    assert_redirected_to price_plans_path
  end
end
