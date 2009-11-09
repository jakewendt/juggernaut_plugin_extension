# see http://refspecs.freestandards.org/LSB_3.1.0/LSB-Core-generic/LSB-Core-generic/iniscrptact.html
# for LSB-compliancy info
#	this file was copied from BackgrounDRb then modified
module Juggernaut
	class StartStop

		CONFIG_FILE = "#{RAILS_ROOT}/config/juggernaut.yml"
		JUGGERNAUT_CONFIG = Juggernaut::Config.read_config(CONFIG_FILE)
		PID_FILE = "#{RAILS_ROOT}/tmp/pids/juggernaut.#{JUGGERNAUT_CONFIG[:port]}.pid"

		def start
			if running? # starting an already running process is considered a success
				puts "Juggernaut Already Running"
				return
			elsif dead? # dead, but pid exists
				remove_pidfiles
			end

			# status == 3, not running.
			STDOUT.sync = true
			print("Starting Juggernaut .... ")
			start_juggernaut
			puts "Success!"
		end

		def stop
			pid_files = Dir["#{RAILS_ROOT}/tmp/pids/juggernaut.*.pid"]
			puts "Juggernaut Not Running" if pid_files.empty?
			pid_files.each do |x|
				begin
					kill_process(x)
				rescue Errno::ESRCH
					# stopping an already stopped process is considered a success (exit status 0)
				end
			end
			remove_pidfiles
		end

		# returns the correct lsb code for the status:
		# 0 program is running or service is OK
		# 1 program is dead and /var/run pid file exists
		# 3 program is not running
		def status
			@status ||= begin
										if pidfile_exists? and process_running?
											0
										elsif pidfile_exists? # but not process_running
											1
										else
											3
										end
									end

			return @status
		end

		def pidfile_exists?; File.exists?(PID_FILE); end

		def process_running?
			begin
				Process.kill(0,self.pid)
				true
			rescue Errno::ESRCH
				false
			end
		end

		def running?;status == 0;end
		# pidfile exists but process isn't running

		def dead?;status == 1;end

		def pid
			File.read(PID_FILE).strip.to_i if pidfile_exists?
		end

		def remove_pidfiles
			require 'fileutils'
			FileUtils.rm_r(Dir["#{RAILS_ROOT}/tmp/pids/juggernaut.*.pid"])
		end

		def start_juggernaut
			Juggernaut::Runner.run([
				"--config",CONFIG_FILE,
				"--pid",PID_FILE,
				"--log","#{RAILS_ROOT}/log/juggernaut.log", 
				"--daemon"
			])
		end

		def kill_process(pid_file)
			pid = File.open(pid_file, "r") { |pid_handle| pid_handle.gets.strip.to_i }
			pgid =	Process.getpgid(pid)
			Process.kill('-TERM', pgid)
			File.delete(pid_file) if File.exists?(pid_file)
			puts "Stopped Juggernaut worker with pid #{pid}"
		end

	end
end
