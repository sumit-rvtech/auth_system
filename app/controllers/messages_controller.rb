class MessagesController < ApplicationController
	before_action :authenticate_user!
	include Warden::Test::Helpers
	include ApplicationHelper

	def new
		@chosen_recipient = User.find_by(id: params[:to].to_i) if params[:to]
	end

	def create
		recipients = User.where(id: params['recipients'])
		conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
		@message = conversation.messages.find_by(body: params[:message][:body])
		flash[:success] = "Message has been sent!"
		send_cable(@message)
		redirect_to conversation_path(conversation)
	end

end
