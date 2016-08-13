# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ActivityChannel < ApplicationCable::Channel
  def subscribed
    stream_from "activity_channel"
  end
 
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    current_user.events.create!(message: data['message'], chat_room_id: data['chat_room_id'])
  end
end
