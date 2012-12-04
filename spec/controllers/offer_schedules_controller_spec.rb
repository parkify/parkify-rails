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

describe OfferSchedulesController do

  # This should return the minimal set of attributes required to create a valid
  # OfferSchedule. As you add validations to OfferSchedule, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OfferSchedulesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all offer_schedules as @offer_schedules" do
      offer_schedule = OfferSchedule.create! valid_attributes
      get :index, {}, valid_session
      assigns(:offer_schedules).should eq([offer_schedule])
    end
  end

  describe "GET show" do
    it "assigns the requested offer_schedule as @offer_schedule" do
      offer_schedule = OfferSchedule.create! valid_attributes
      get :show, {:id => offer_schedule.to_param}, valid_session
      assigns(:offer_schedule).should eq(offer_schedule)
    end
  end

  describe "GET new" do
    it "assigns a new offer_schedule as @offer_schedule" do
      get :new, {}, valid_session
      assigns(:offer_schedule).should be_a_new(OfferSchedule)
    end
  end

  describe "GET edit" do
    it "assigns the requested offer_schedule as @offer_schedule" do
      offer_schedule = OfferSchedule.create! valid_attributes
      get :edit, {:id => offer_schedule.to_param}, valid_session
      assigns(:offer_schedule).should eq(offer_schedule)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new OfferSchedule" do
        expect {
          post :create, {:offer_schedule => valid_attributes}, valid_session
        }.to change(OfferSchedule, :count).by(1)
      end

      it "assigns a newly created offer_schedule as @offer_schedule" do
        post :create, {:offer_schedule => valid_attributes}, valid_session
        assigns(:offer_schedule).should be_a(OfferSchedule)
        assigns(:offer_schedule).should be_persisted
      end

      it "redirects to the created offer_schedule" do
        post :create, {:offer_schedule => valid_attributes}, valid_session
        response.should redirect_to(OfferSchedule.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved offer_schedule as @offer_schedule" do
        # Trigger the behavior that occurs when invalid params are submitted
        OfferSchedule.any_instance.stub(:save).and_return(false)
        post :create, {:offer_schedule => {}}, valid_session
        assigns(:offer_schedule).should be_a_new(OfferSchedule)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        OfferSchedule.any_instance.stub(:save).and_return(false)
        post :create, {:offer_schedule => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested offer_schedule" do
        offer_schedule = OfferSchedule.create! valid_attributes
        # Assuming there are no other offer_schedules in the database, this
        # specifies that the OfferSchedule created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        OfferSchedule.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => offer_schedule.to_param, :offer_schedule => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested offer_schedule as @offer_schedule" do
        offer_schedule = OfferSchedule.create! valid_attributes
        put :update, {:id => offer_schedule.to_param, :offer_schedule => valid_attributes}, valid_session
        assigns(:offer_schedule).should eq(offer_schedule)
      end

      it "redirects to the offer_schedule" do
        offer_schedule = OfferSchedule.create! valid_attributes
        put :update, {:id => offer_schedule.to_param, :offer_schedule => valid_attributes}, valid_session
        response.should redirect_to(offer_schedule)
      end
    end

    describe "with invalid params" do
      it "assigns the offer_schedule as @offer_schedule" do
        offer_schedule = OfferSchedule.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OfferSchedule.any_instance.stub(:save).and_return(false)
        put :update, {:id => offer_schedule.to_param, :offer_schedule => {}}, valid_session
        assigns(:offer_schedule).should eq(offer_schedule)
      end

      it "re-renders the 'edit' template" do
        offer_schedule = OfferSchedule.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OfferSchedule.any_instance.stub(:save).and_return(false)
        put :update, {:id => offer_schedule.to_param, :offer_schedule => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested offer_schedule" do
      offer_schedule = OfferSchedule.create! valid_attributes
      expect {
        delete :destroy, {:id => offer_schedule.to_param}, valid_session
      }.to change(OfferSchedule, :count).by(-1)
    end

    it "redirects to the offer_schedules list" do
      offer_schedule = OfferSchedule.create! valid_attributes
      delete :destroy, {:id => offer_schedule.to_param}, valid_session
      response.should redirect_to(offer_schedules_url)
    end
  end

end
