require 'test_helper'

class ResourceOffersControllerTest < ActionController::TestCase
  setup do
    @resource_offer = resource_offers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resource_offers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource_offer" do
    assert_difference('ResourceOffer.count') do
      post :create, resource_offer: { active: @resource_offer.active, description: @resource_offer.description, location_id: @resource_offer.location_id, sign_id: @resource_offer.sign_id, title: @resource_offer.title, user_id: @resource_offer.user_id }
    end

    assert_redirected_to resource_offer_path(assigns(:resource_offer))
  end

  test "should show resource_offer" do
    get :show, id: @resource_offer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resource_offer
    assert_response :success
  end

  test "should update resource_offer" do
    put :update, id: @resource_offer, resource_offer: { active: @resource_offer.active, description: @resource_offer.description, location_id: @resource_offer.location_id, sign_id: @resource_offer.sign_id, title: @resource_offer.title, user_id: @resource_offer.user_id }
    assert_redirected_to resource_offer_path(assigns(:resource_offer))
  end

  test "should destroy resource_offer" do
    assert_difference('ResourceOffer.count', -1) do
      delete :destroy, id: @resource_offer
    end

    assert_redirected_to resource_offers_path
  end
end
