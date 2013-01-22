class Api::V2::UsersPresenter < Api::V2::ApplicationPresenter
  
  def as_json(user, options={})
    #result = user.as_json(:only => [:id, :first_name, :last_name, :email, :phone_number, :credit])
    result = {}    
    result["id"] = user.id
    result["first_name"] = user.first_name
    result["last_name"] = user.last_name
    result["email"] = user.email
    result["phone_number"] = user.phone_number
    result["credit"] = user.credit
    result["credit_cards"] = user.cards.as_json
    result["cars"] = user.cars.as_json
    result["promos"] = user.promo_users.as_json
    result
  end
  
end
