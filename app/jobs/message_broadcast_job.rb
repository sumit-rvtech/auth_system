class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conv,user)
    ActionCable.server.broadcast 'message_channel', message: render_inbox(conv,user), convo_id: conv.id
  end
 
  private

  def render_inbox(event,user)
  	ApplicationController.renderer.render(partial: 'conversations/conversation', locals: { conversation: event,current_user: user})
  end
end
