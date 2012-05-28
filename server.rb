require 'socket'
require 'pp'

s = UDPSocket.new
s.bind('0.0.0.0', 1234)

loop do
  text, sender = s.recvfrom(16)
  puts text
  PP.pp sender
end

