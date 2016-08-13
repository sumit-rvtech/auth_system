App.activity = App.cable.subscriptions.create "ActivityChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
 
  disconnected: ->
    # Called when the subscription has been terminated by the server
 
  received: (event) ->
    # Called when there's incoming data on the websocket for this channel
    $("#events_#{event.user}").prepend("<div class='event'>#{event.message}</div>")

   send_message: (event, receiver_id) ->
        @perform 'send_message', message: message, receiver: receiver_id


    $('#new_message').submit (e) ->
      $this = $(this)
      textarea = $this.find('#message_body')
      if $.trim(textarea.val()).length > 1
        App.global_chat.send_message textarea.val(), messages.data('chat-room-id')
        textarea.val('')
      e.preventDefault()
      return false
