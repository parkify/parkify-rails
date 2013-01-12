require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe FlatRatePricesController do

  # This should return the minimal set of attributes required to create a valid
  # FlatRatePrice. As you add validations to FlatRatePrice, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FlatRatePricesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all flat_rate_prices as @flat_rate_prices" do
      flat_rate_price = FlatRatePrice.create! valid_attributes
      get :index, {}, valid_session
      assigns(:flat_rate_prices).should eq([flat_rate_price])
    end
  end

  describe "GET show" do
    it "assigns the requested flat_rate_price as @flat_rate_price" do
      flat_rate_price = FlatRatePrice.create! valid_attributes
      get :show, {:id => flat_rate_price.to_param}, valid_session
      assigns(:flat_rate_price).should eq(flat_rate_price)
    end
  end

  describe "GET new" do
    it "assigns a new flat_rate_price as @flat_rate_price" do
      get :new, {}, valid_session
      assigns(:flat_rate_price).should be_a_new(FlatRatePrice)
    end
  end

  describe "GET edit" do
    it "assigns the requested flat_rate_price as @flat_rate_price" do
      flat_rate_price = FlatRatePrice.create! valid_attributes
      get :edit, {:id => flat_rate_price.to_param}, valid_session
      assigns(:flat_rate_price).should eq(flat_rate_price)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FlatRatePrice" do
        expect {
          post :create, {:flat_rate_price => valid_attributes}, valid_session
        }.to change(FlatRatePrice, :count).by(1)
      end

      it "assigns a newly created flat_rate_price as @flat_rate_price" do
        post :create, {:flat_rate_price => valid_attributes}, valid_session
        assigns(:flat_rate_price).should be_a(FlatRatePrice)
        assigns(:flat_rate_price).should be_persisted
      end

      it "redirects to the created flat_rate_price" do
        post :create, {:flat_rate_price => valid_attributes}, valid_session
        response.should redirect_to(FlatRatePrice.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved flat_rate_price as @flat_rate_price" do
        # Trigger the behavior that occurs when invalid params are submitted
        FlatRatePrice.any_instance.stub(:save).and_return(false)
        post :create, {:flat_rate_price => {}}, valid_session
        assigns(:flat_rate_price).should be_a_new(FlatRatePrice)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        FlatRatePrice.any_instance.stub(:save).and_return(false)
        post :create, {:flat_rate_price => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested flat_rate_price" do
        flat_rate_price = FlatRatePrice.create! valid_attributes
        # Assuming there are no other flat_rate_prices in the database, this
        # specifies that the FlatRatePrice created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        FlatRatePrice.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => flat_rate_price.to_param, :flat_rate_price => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested flat_rate_price as @flat_rate_price" do
        flat_rate_price = FlatRatePrice.create! valid_attributes
        put :update, {:id => flat_rate_price.to_param, :flat_rate_price => valid_attributes}, valid_session
        assigns(:flat_rate_price).should eq(flat_rate_price)
      end

      it "redirects to the flat_rate_price" do
        flat_rate_price = FlatRatePrice.create! valid_attributes
        put :update, {:id => flat_rate_price.to_param, :flat_rate_price => valid_attributes}, valid_session
        response.should redirect_to(flat_rate_price)
      end
    end

    describe "with invalid params" do
      it "assigns the flat_rate_price as @flat_rate_price" do
        flat_rate_price = FlatRatePrice.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FlatRatePrice.any_instance.stub(:save).and_return(false)
        put :update, {:id => flat_rate_price.to_param, :flat_rate_price => {}}, valid_session
        assigns(:flat_rate_price).should eq(flat_rate_price)
      end

      it "re-renders the 'edit' template" do
        flat_rate_price = FlatRatePrice.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FlatRatePrice.any_instance.stub(:save).and_return(false)
        put :update, {:id => flat_rate_price.to_param, :flat_rate_price => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested flat_rate_price" do
      flat_rate_price = FlatRatePrice.create! valid_attributes
      expect {
        delete :destroy, {:id => flat_rate_price.to_param}, valid_session
      }.to change(FlatRatePrice, :count).by(-1)
    end

    it "redirects to the flat_rate_prices list" do
      flat_rate_price = FlatRatePrice.create! valid_attributes
      delete :destroy, {:id => flat_rate_price.to_param}, valid_session
      response.should redirect_to(flat_rate_prices_url)
    end
  end

end