class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  before_save :ensure_authentication_token
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :company_name, :billing_address, :company_phone_number, :zip_code, :phone_number, :credit
  # attr_accessible :title, :body
  
  has_many :cars, :dependent => :destroy
  has_many :stripe_customer_ids, :dependent => :destroy
  has_many :resources, :dependent => :destroy
  has_many :acceptances
  
  
  has_many :promo_users
  has_many :promos, :through => :promo_users
  has_many :codes, :through => :promo_users
  
  def active_card
    return self.stripe_customer_ids.where('active_customer = ?', true).first
  end
  
  def activate_card(card)
    if(!card)
      return false
    end
    #verify that card is one of this user's cards
    if(!self.stripe_customer_ids.where(:id => card.id).present?)
      return false
    else
      #set all other cards to false.
      self.stripe_customer_ids.each do |cardEach|
        if(cardEach.id == card.id)
          cardEach.active_customer = true
          cardEach.save
        elsif (cardEach.active_customer)
          cardEach.active_customer = false
          cardEach.save
        end
      end
      
      return true
    end
  end
  
  def validate_cards
    return self.stripe_customer_ids.where('active_customer = ?', true).count == 1
  end
  
  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end
  
  def save_with_card_and_car!(stripe_token_id, license_plate)
    if(stripe_token_id) #TODO: Maybe better check actual validity of token
    
      #Add the credit card and make a new customer.
      customer = Stripe::Customer.create(
        :card => stripe_token_id,
        :description => email
      )
      if (customer.active_card.cvc_check != "pass") 
        self.errors.add(:card, "Card failed CVC check")
        return false
      end
     
      return false unless save()
      
      
      self.stripe_customer_ids.create(:customer_id => customer.id, :active_customer => true, :last4 => customer.active_card.last4)
      self.cars.create(:license_plate_number => license_plate, :active_car => true)
      
      send_welcome_email
      
    else
      self.errors.add(:card, "Invalid Card")
      return false
    end
  end
  
  def save_with_new_card!(stripe_token_id)
    if(stripe_token_id) #TODO: Maybe check actual validity of token
    
      #Add the credit card and make a new customer.
      customer = Stripe::Customer.create(
        :card => stripe_token_id,
        :description => email
      )
      if (customer.active_card.cvc_check != "pass") 
        self.errors.add(:card, "Card failed CVC check")
        return false
      end
     
    
      return false unless save()
      
      if(self.stripe_customer_ids.count == 0)
        self.stripe_customer_ids.create(:customer_id => customer.id, :active_customer => true, :last4 => customer.active_card.last4)
      else
        self.stripe_customer_ids.create(:customer_id => customer.id, :active_customer => false, :last4 => customer.active_card.last4)
      end
      
      return true
      
    else
      self.errors.add(:card, "Invalid Card")
      return false
    end
  end
  
  def save_with_new_car!(license_plate_number)
    if(license_plate_number)
    
      if(!self.save())
        return false
      end
      
      car = self.cars.new({:license_plate_number => license_plate_number, :active_car => true})
      
      if(!car.save)
        self.errors.add(:car, car.errors.values[0])
        return false
      end
      
      return true
      
    else
      self.errors.add(:car, "Invalid license plate number")
      return false
    end
  end
  
  def save_with_new_promo!(code_text)
    if(code_text)
      c = Code.find_by_code_text(code_text)
      if(!c)
        self.errors.add(:code, "code invalid")
        return false
      end
      
      if(c.personal && c.users.count > 0)
        self.errors.add(:code, "code already used")
        return false
      end
      
      promo = c.promo
      if(!promo)
        self.errors.add(:code, "code invalid")
        return false
      end
      
      if(!self.save())
        return false
      end
      
      self.promos << promo
      
      promo_users = self.promo_users.find_by_promo_id(promo.id)
      promo_users.code = c
      if(!promo_users.save)
        self.errors.add(:code, "code invalid")
        return false
      end
      
      if(promo.of_type('once'))
        promo.perform_action(self)
      end
      return true
      
    else
      self.errors.add(:code, "code invalid")
      return false
    end
  end
  
  
  def update_cars (cars)
    if(!cars)
      return nil
    else
      toRtn = nil
      cars.each do |cHash|
        c = Car.find_by_id(cHash["id"])
        if (c.license_plate_number != cHash["license_plate_number"])
          c.license_plate_number = cHash["license_plate_number"];
          if(!c.save)
            toRtn = c.errors
          end
        end
      end
      return toRtn
    end
  end
  
  
  def method_missing(meth, *args, &block)
    puts meth, args, block
    super # You *must* call super if you don't handle the
                # method, otherwise you'll mess up Ruby's method
                # lookup.s
    
  end
  
  def as_json(options={})
    result = super(:only => [:id, :first_name, :last_name, :email, :phone_number, :credit])
    
    result["credit_cards"] = self.stripe_customer_ids.as_json
    result["cars"] = self.cars.as_json
    #result["promos"] =
    result
  end
  
end
