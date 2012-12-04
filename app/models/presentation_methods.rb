module PresentationMethods

  # Overwrite as_json to allow presenters.
  #if (respond_to?('as_json'))
  #  alias_method :original_as_json, :as_json
  #end
  def as_json(options={})
    if (options[:presenter])
      return options[:presenter].as_json(self, options)
    elsif (respond_to?('super'))
      return super(options)
    else
      return {}
    end
  end

end

class ActiveRecord::Base

  #include PresentationMethods
end
