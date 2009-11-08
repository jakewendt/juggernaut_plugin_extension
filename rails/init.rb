require 'juggernaut_config'
require 'juggernaut_start_stop'

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :jqjuggernaut => [ 'juggernaut/json', 'juggernaut/juggernaut', 'juggernaut/jquerynaut', 'juggernaut/swfobject' ]
