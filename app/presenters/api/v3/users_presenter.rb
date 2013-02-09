class Api::V3::UsersPresenter < Api::V3::ApplicationPresenter
  
  def as_json(user, options={})
    #result = user.as_json(:only => [:id, :first_name, :last_name, :email, :phone_number, :credit])
    result = {}    
    result["id"] = user.id
    result["first_name"] = self.no_nil(user.first_name)
    result["last_name"] = self.no_nil(user.last_name)
    result["email"] = self.no_nil(user.email)
    result["phone_number"] = self.no_nil(user.phone_number)
    result["credit"] = self.no_nil(user.credit)
    result["credit_cards"] = self.no_nil(user.cards.as_json)
    result["cars"] = user.cars.as_json
    result["promos"] = user.promo_users.as_json
    result["account_type"] = self.no_nil(user.account_type)
    if(user.trial?)
      result["needed_for_update"] = user.needed_for_update
    end
    result
  end

  def no_nil(input)
    return input.nil? "" : input
  end
  
end
