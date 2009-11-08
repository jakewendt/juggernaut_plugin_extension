require 'fileutils'

here = File.dirname(__FILE__)
there = defined?(RAILS_ROOT) ? RAILS_ROOT : "#{here}/../../.."

puts "Installing Juggernaut Plugin Extension ..."

FileUtils.cp("#{here}/script/juggernaut", "#{there}/script/") unless File.exist?("#{there}/script/juggernaut")

puts "Juggernaut Plugin Extension has been successfully installed."
