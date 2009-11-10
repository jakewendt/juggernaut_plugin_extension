require 'juggernaut_config'
require 'juggernaut_start_stop'

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :jqjuggernaut => [ 'juggernaut/json', 'juggernaut/juggernaut', 'juggernaut/jquerynaut', 'juggernaut/swfobject' ]

Juggernaut.module_eval do
	class << self
		#	The missing method.  The juggernaut_plugin documentation says this exists,
		#	but it doesn't.  No big deal since its just an alias as are several others.
		#	Nevertheless, now it works.
		alias send_to_client_on_channel send_to_clients_on_channels
	end
end

#	This is required when testing and using juggernaut.  The helper calls
#		request.session_options[:id]
#	In development and production request is a Request
#	but in test it is a TestRequest which 
#	session_options is nil
ActionController::TestRequest.class_eval do
	def session_options
		{ :id => '12345' }
	end
end if RAILS_ENV == 'test'
