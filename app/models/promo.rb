class Promo < ActiveRecord::Base
  attr_accessible :description, :end_time, :name, :start_time, :promo_type, :value1, :value2

  has_many :codes
  has_many :promo_users
  has_many :users, :through => :promo_users
  
  def generate_unique_codes(count, personal)
    if count == 1
      fallback = 100000
      while fallback > 0 
        a = SecureRandom::hex(4)
        if(!Code.find_by_code_text(a))
          return [ self.codes.create({:code_text=>a, :personal=>personal}) ]
        end
        fallback = fallback - 1
      end
      return nil
    else 
      toRtn = []
      count.times do |c|
        toRtn += self.generate_unique_codes(1, personal)
      end
      return toRtn
    end
  end
  
  
  def of_type?(type)
    return self.promo_type && self.promo_type.include?('['+type+']')
  end
  
  def active?
    
    toRtn = true
    if self.start_time
      toRtn &= self.start_time <= Time.now
    end
    
    if self.end_time
      toRtn &= self.end_time >= Time.now
    end
    
    toRtn
  end
  
  def perform_action(user)  
    if self.of_type?('add_credits') and self.active?
      user.credit += self.value1
    end
  end
  
  def discount(amount)  
    if self.of_type?('discount') and self.active?
      return self.value1 * amount
    else
      return amount
    end
  end
  
    
    
    
  
end
