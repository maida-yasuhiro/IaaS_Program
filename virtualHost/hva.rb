require 'drb/drb'
require 'thread'
require 'libvirt'

class Server

	def initialize( queue )
		#$B%-%e!<(B
		@queue = queue
		Thread.new do
			message_loop
		end
	end

	def message_loop
		loop do
			prms = @queue.deq

			case prms[:prm]
			when "clone"
				system("/root/centos-new.sh #{prms[:guestname]} #{prms[:cpu]} \
					   #{prms[:mem]} #{prms[:guest_size]} #{prms[:owner]} \
					   #{prms[:password]} & ")
			when "start"
				#$B%7%'%k%9%/%j%W%HL$:n@.(B
				system("/root/start-vm.sh #{prms[:guestname]} & ")
			when "shutdown"
				#$B%7%'%k%9%/%j%W%HL$:n@.(B
				system("/root/shutdown-vm.sh #{prms[:guestname]} & ")
			when "delete"
				system("/root/delete-vm.sh #{prms[:guestname]} & ")
			end
		end
	end

	q = Queue.new
	server = Server.new( q )
	DRb.start_service('druby://192.168.1.13:8787',q)
	puts DRb.uri
	DRb.thread.join

end
