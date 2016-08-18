class Api::ConversationsController < ApplicationController
	before_action :authenticate_user!
	before_action :get_mailbox
	before_action :get_conversation, except: [:index, :empty_trash]
	before_action :get_box, only: [:index]
	include ApplicationHelper

	def index
		if @box.eql? "inbox"
			@conversations = @mailbox.inbox
		elsif @box.eql? "sent"
			@conversations = @mailbox.sentbox
		else
			@conversations = @mailbox.trash
		end
		@conversations = @conversations.paginate(page: params[:page], per_page: 10)
		data=[]
		@conversations.reverse.each do |c|
			data<< { "conversation_#{c.id}": c, "messages_#{c.id}": c.messages }
		end
		respond_to do |format|
			format.json { render json: { conversations: data }}
			format.xml { render xml: { conversations: @conversations }}
		end
	end

	def show
		respond_to do |format|
			format.json { render json: @conversation }
			format.xml { render xml: @conversation }
		end
	end

	def mark_as_read
		@conversation.mark_as_read(current_user)
		respond_to do |format|
			format.json { render json: @conversation, message: 'The conversation was marked as read.' }
			format.xml { render xml: @conversation , message: 'The conversation was marked as read.'}
		end
	end

	def reply
		current_user.reply_to_conversation(@conversation, params[:body])
		@message = @conversation.messages.find_by(body: params[:body])
		send_cable(@message)
		respond_to do |format|
			format.json { render json: @conversation, message: 'Reply sent'}
			format.xml { render xml: @conversation , message: 'Reply sent'}
		end
	end

	def destroy
		@conversation.move_to_trash(current_user)
		respond_to do |format|
			format.json { render json: @conversation, message: 'The conversation was moved to trash.'}
			format.xml { render xml: @conversation , message: 'The conversation was moved to trash.'}
		end
	end

	def restore
		@conversation.untrash(current_user)
		respond_to do |format|
			format.json { render json: @conversation, message: 'The conversation was restored.'}
			format.xml { render xml: @conversation , message: 'The conversation was restored.'}
		end
	end

	def empty_trash
		@mailbox.trash.each do |conversation|
			conversation.receipts_for(current_user).update_all(deleted: true)
		end
		respond_to do |format|
			format.json { render json: @conversation, message: 'Your trash was cleaned!'}
			format.xml { render xml: @conversation , message: 'Your trash was cleaned!'}
		end
	end

	private

	def get_mailbox
		@mailbox ||= current_user.mailbox
	end

	def get_conversation
		@conversation ||= @mailbox.conversations.find(params[:id])
	end

	def get_box
		if params[:box].blank? or !["inbox","sent","trash"].include?(params[:box])
			params[:box] = 'inbox'
		end
		@box = params[:box]
	end
end
