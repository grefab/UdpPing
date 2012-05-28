require 'rubygems'
require 'socket'
require 'pp'


@server_udp_port = 1234
@drone_udp_port = 4567

def broadcast_msg(content, udp_port)
  body = {:reply_port => @drone_udp_port, :content => content}

  s = UDPSocket.new
  s.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
  s.send(Marshal.dump(body), 0, '<broadcast>', udp_port)
  s.close
end

def start_server_listener(&code)
  Thread.fork do
    s = UDPSocket.new
    s.bind('0.0.0.0', @drone_udp_port)

    body, sender = s.recvfrom(1024)

    server_ip = sender[3]
    data = Marshal.load(body)
    code.call(data, server_ip)
  end
end

def query_server content
  broadcast_msg(content, @server_udp_port)
end


def handle_server_answer(data, server_ip)
  puts "Queen: #{server_ip}:#{data[:port]}"
end

thread = start_server_listener do |data, server_ip|
  handle_server_answer(data, server_ip)
end

query_server "xxx"

thread.join


