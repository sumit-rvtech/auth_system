class EventsController < ApplicationController
	before_action :find_user, only: [:send_messages, :receive_messages, :reply_message]
  def index
    @events = current_user.events.where(sender_id: current_user.id).reverse
  end

  def new
  	@event = current_user.events.new
  end

  def create
  	@event = current_user.events.new(event_params)
  	@event.read = true
  	@recipient = @event.receiver_id

  	respond_to do |format|
      if @event.save
      	current_user.send_message(@recipient, @event.subject, @event.message)
        format.html { redirect_to events_path	, notice: 'Message was successfully sent.' }
        format.json { render :index, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_messages
  	@events = @user.events.where(sender_id: current_user.id)
  end

  def receive_messages
  	@events = @user.events.where(receiver_id: current_user.id)
  end

  def show
  	@event = current_user.events.find(params[:id])
  end

  def reply_message
  	debugger
  end

  private

  def event_params
  	params.require(:event).permit!
  end

  def find_user
  	@user = User.find(params[:user_id])
  end
end
