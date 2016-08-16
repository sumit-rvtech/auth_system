class EventBroadcastJob < ApplicationJob
  queue_as :default
 
  def perform(event,user)
    message = Mailboxer::Receipt.where(notification_id: event).first
    ActionCable.server.broadcast 'activity_channel', message: render_event(message)
  end
 
  private
 
  def render_event(event)
    ApplicationController.renderer.render(partial: 'conversations/convers', locals: { receipt: event})
  end
end