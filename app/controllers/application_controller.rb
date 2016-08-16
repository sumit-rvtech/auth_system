class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :authenticate_user!

	before_action :my_current_user

	rescue_from ActiveRecord::RecordNotFound do
		flash[:warning] = 'Resource not found.'
		redirect_back_or root_path
	end

	def redirect_back_or(path)
		redirect_to request.referer || path
	end

	def my_current_user
		@my_current_user = current_user
	end
end
