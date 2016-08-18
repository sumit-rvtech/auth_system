class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :authenticate_user!
	before_action :authenticate_user_from_token!
	before_action :my_current_user
	include ApplicationHelper

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

	def authenticate_user_from_token!
		user_email = request.headers["X-API-EMAIL"].presence
		user_auth_token = request.headers["X-API-TOKEN"].presence
		user = user_email && User.find_by_email(user_email)

		# Notice how we use Devise.secure_compare to compare the token
		# in the database with the token given in the params, mitigating
		# timing attacks.
		if user && Devise.secure_compare(user.authentication_token, user_auth_token)
		  sign_in(user, store: false)
		end
	end

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
		#devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
	end
end
