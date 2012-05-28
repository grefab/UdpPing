require 'rubygems'
require 'socket'
require 'pp'


@drone_udp_port = 12345

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

def query_server(content, server_udp_port, &code)
  thread = start_server_listener do |data, server_ip|
    code.call(data, server_ip)
  end
  
  broadcast_msg(content, server_udp_port) 
  
  thread.join
end


query_server "xxx", 1234 do |data, server_ip|
  puts "Queen: #{server_ip}:#{data[:port]}"
end





