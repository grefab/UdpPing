require 'rubygems'
require 'socket'
require 'json'
require 'pp'


@queen_udp_port = 1234
@drone_udp_port = 4567

def broadcast_msg(message, udp_port)
  s = UDPSocket.new
  s.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
  s.send(message, 0, '<broadcast>', udp_port)
end

def handle_queen_answer(body, sender)
  data = Marshal.load body

  queen_ip = sender[3]
  queen_port = data[:port]

  puts "Queen: #{queen_ip}:#{queen_port}"
end

def start_queen_listener
  Thread.fork do
    s = UDPSocket.new
    s.bind('0.0.0.0', @drone_udp_port)

    loop do
      body, sender = s.recvfrom(1024)
      handle_queen_answer(body, sender)
    end
  end
end

def query_queen
  message = {:type => "drone", :port => @drone_udp_port}
  broadcast_msg(Marshal.dump(message), @queen_udp_port)
end

start_queen_listener
sleep 1
query_queen
sleep 1

