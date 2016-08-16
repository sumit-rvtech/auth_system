module ApplicationHelper
	def gravatar_for(user, size = 30, title = user.name)
		image_tag gravatar_image_url(user.email, size: size), title: title, class: 'img-rounded'
	end

	def page_header(text)
		content_for(:page_header) { text.to_s }
	end

	def recipients_options(chosen_recipient = nil)
    	s = ''
	    User.all_except(current_user).each do |user|
	      s << "<option value='#{user.id}' data-img-src='#{gravatar_image_url(user.email, size: 50)}' #{'selected' if user == chosen_recipient}>#{user.name}</option>"
	    end
    	s.html_safe
  	end

	def send_cable message
		EventBroadcastJob.perform_now(message,current_user)
	end
end
