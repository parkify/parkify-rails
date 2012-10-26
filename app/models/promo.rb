class Promo < ActiveRecord::Base
  attr_accessible :description, :end_time, :name, :start_time, :type, :value1, :value2

  has_many :codes
  
  def generate_unique_codes(count, personal)
    if(count == 1)
      fallback = 100000
      while(fallback > 0)
        a = SecureRandom::hex(4)
        if(!Code.find_by_code_text(a))
          return [ self.codes.create({:code_text=>a, :personal=>personal}) ]
          break
        end
        fallback--
      end
      return nil
      
    else 
      toRtn = []
      count.times do |c|
        toRtn += generate_unique_codes(1, personal)
      end
      return toRtn
    end
  end
  
end
