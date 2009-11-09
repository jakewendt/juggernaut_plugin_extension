require 'juggernaut_config'
require 'juggernaut_start_stop'

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :jqjuggernaut => [ 'juggernaut/json', 'juggernaut/juggernaut', 'juggernaut/jquerynaut', 'juggernaut/swfobject' ]

#	This is required when testing and using juggernaut.  The helper calls
#		request.session_options[:id]
#	In development and production request is a Request
#	but in test it is a TestRequest which does not seem to respond to 
#	session_options even though it should, so ...
ActionController::TestRequest.class_eval do
        def session_options
                { :id => '12345' }
        end
end if RAILS_ENV == 'test'
