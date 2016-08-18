class Api::UsersController < ApplicationController

	skip_before_filter :authenticate_user!
	before_filter :fetch_user, :except => [:index, :create]


	def index
		@users = User.all
		respond_to do |format|
			format.json { render json: @users }
			format.xml { render xml: @users }
		end
	end

	def create
		@user = User.new(user_params)
		respond_to do |format|
			if @user.save
				format.json { render json: @user, status: :created }
				format.xml { render xml: @user, status: :created }
			else
				format.json { render json: @user.errors, status: :unprocessable_entity }
				format.xml { render xml: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	private

	def user_params
		params.require(:user).permit!
	end

	def fetch_user
		@user = User.find_by_id(params[:id])
	end
end
