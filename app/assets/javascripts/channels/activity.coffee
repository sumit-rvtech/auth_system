App.activity = App.cable.subscriptions.create "ActivityChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
 
  disconnected: ->
    # Called when the subscription has been terminated by the server
 
  received: (event) ->
    # Called when there's incoming data on the websocket for this channel
    debugger
    $("#events_#{event.user}").prepend("<div class='event'>#{event.message}</div>")

   send_message: (event, receiver_id) ->
        @perform 'send_message', message: message, receiver: receiver_id
