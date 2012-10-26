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

describe PromoUsersController do

  # This should return the minimal set of attributes required to create a valid
  # PromoUser. As you add validations to PromoUser, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PromoUsersController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all promo_users as @promo_users" do
      promo_user = PromoUser.create! valid_attributes
      get :index, {}, valid_session
      assigns(:promo_users).should eq([promo_user])
    end
  end

  describe "GET show" do
    it "assigns the requested promo_user as @promo_user" do
      promo_user = PromoUser.create! valid_attributes
      get :show, {:id => promo_user.to_param}, valid_session
      assigns(:promo_user).should eq(promo_user)
    end
  end

  describe "GET new" do
    it "assigns a new promo_user as @promo_user" do
      get :new, {}, valid_session
      assigns(:promo_user).should be_a_new(PromoUser)
    end
  end

  describe "GET edit" do
    it "assigns the requested promo_user as @promo_user" do
      promo_user = PromoUser.create! valid_attributes
      get :edit, {:id => promo_user.to_param}, valid_session
      assigns(:promo_user).should eq(promo_user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PromoUser" do
        expect {
          post :create, {:promo_user => valid_attributes}, valid_session
        }.to change(PromoUser, :count).by(1)
      end

      it "assigns a newly created promo_user as @promo_user" do
        post :create, {:promo_user => valid_attributes}, valid_session
        assigns(:promo_user).should be_a(PromoUser)
        assigns(:promo_user).should be_persisted
      end

      it "redirects to the created promo_user" do
        post :create, {:promo_user => valid_attributes}, valid_session
        response.should redirect_to(PromoUser.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved promo_user as @promo_user" do
        # Trigger the behavior that occurs when invalid params are submitted
        PromoUser.any_instance.stub(:save).and_return(false)
        post :create, {:promo_user => {}}, valid_session
        assigns(:promo_user).should be_a_new(PromoUser)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        PromoUser.any_instance.stub(:save).and_return(false)
        post :create, {:promo_user => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested promo_user" do
        promo_user = PromoUser.create! valid_attributes
        # Assuming there are no other promo_users in the database, this
        # specifies that the PromoUser created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        PromoUser.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => promo_user.to_param, :promo_user => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested promo_user as @promo_user" do
        promo_user = PromoUser.create! valid_attributes
        put :update, {:id => promo_user.to_param, :promo_user => valid_attributes}, valid_session
        assigns(:promo_user).should eq(promo_user)
      end

      it "redirects to the promo_user" do
        promo_user = PromoUser.create! valid_attributes
        put :update, {:id => promo_user.to_param, :promo_user => valid_attributes}, valid_session
        response.should redirect_to(promo_user)
      end
    end

    describe "with invalid params" do
      it "assigns the promo_user as @promo_user" do
        promo_user = PromoUser.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PromoUser.any_instance.stub(:save).and_return(false)
        put :update, {:id => promo_user.to_param, :promo_user => {}}, valid_session
        assigns(:promo_user).should eq(promo_user)
      end

      it "re-renders the 'edit' template" do
        promo_user = PromoUser.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PromoUser.any_instance.stub(:save).and_return(false)
        put :update, {:id => promo_user.to_param, :promo_user => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested promo_user" do
      promo_user = PromoUser.create! valid_attributes
      expect {
        delete :destroy, {:id => promo_user.to_param}, valid_session
      }.to change(PromoUser, :count).by(-1)
    end

    it "redirects to the promo_users list" do
      promo_user = PromoUser.create! valid_attributes
      delete :destroy, {:id => promo_user.to_param}, valid_session
      response.should redirect_to(promo_users_url)
    end
  end

end