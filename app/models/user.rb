class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  before_save :ensure_authentication_token
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  # attr_accessible :title, :body
  
  has_many :cars, :dependent => :destroy
  has_many :stripe_customer_ids, :dependent => :destroy
  has_many :resources, :dependent => :destroy
  
  def save_with_card_and_car!(stripe_token_id)
    if(stripe_token_id) #TODO: Maybe check actual validity of token
    
      logger.info "err3..."
      return false unless save()
      logger.info "err4..."
      #Add the credit card and make a new customer.
      customer = Stripe::Customer.create(
        :card => stripe_token_id,
        :description => email
      )
      
      self.stripe_customer_ids.create(:customer_id => customer.id, :stripe_token_id => stripe_token_id, :active_customer => true)
      
    else
      self.errors.add(:card, "Invalid Card")
      return false
    end
  end
  
  
end
