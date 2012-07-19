require 'test_helper'

class StripeCustomerIdsControllerTest < ActionController::TestCase
  setup do
    @stripe_customer_id = stripe_customer_ids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stripe_customer_ids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stripe_customer_id" do
    assert_difference('StripeCustomerId.count') do
      post :create, stripe_customer_id: {  }
    end

    assert_redirected_to stripe_customer_id_path(assigns(:stripe_customer_id))
  end

  test "should show stripe_customer_id" do
    get :show, id: @stripe_customer_id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stripe_customer_id
    assert_response :success
  end

  test "should update stripe_customer_id" do
    put :update, id: @stripe_customer_id, stripe_customer_id: {  }
    assert_redirected_to stripe_customer_id_path(assigns(:stripe_customer_id))
  end

  test "should destroy stripe_customer_id" do
    assert_difference('StripeCustomerId.count', -1) do
      delete :destroy, id: @stripe_customer_id
    end

    assert_redirected_to stripe_customer_ids_path
  end
end
