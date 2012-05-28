require 'socket'

def broadcast_msg(message, port)
  s = UDPSocket.new
  s.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
  s.send(message, 0, '<broadcast>', port)
end

broadcast_msg "mass-ping", 1234

