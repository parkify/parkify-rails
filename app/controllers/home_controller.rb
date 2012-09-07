class HomeController < ApplicationController
  def index
  end
  def core_index
    current_user.send_welcome_email unless !user_signed_in?
  end
  def faq
  end
  def about
  end
  def contact
  end
  def tos
  end
  def privacy
  end
end
