jQuery(document).on 'turbolinks:load', ->
	messages_to_bottom = (message, id) ->
		if $("#message").find(".conversation_"+id).length
			$("#message").find(".conversation_"+id).html(message);
		else
			$("#message").append(message);

	App.message = App.cable.subscriptions.create "MessageChannel",
	  connected: ->
	    # Called when the subscription is ready for use on the server

	  disconnected: ->
	    # Called when the subscription has been terminated by the server

	  received: (data) ->
	    # Called when there's incoming data on the websocket for this channel
	    messages_to_bottom(data.message, data.convo_id)