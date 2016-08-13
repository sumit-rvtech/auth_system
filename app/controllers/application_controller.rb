class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :my_current_user

  def my_current_user
  	@my_current_user = current_user
  end
end
