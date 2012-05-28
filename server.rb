require 'rubygems'
require 'socket'
require 'pp'


@queen_udp_port = 1234
@queen_http_port = 4567

def inform_drone(ip, port, content)
  s = UDPSocket.new
  s.send(Marshal.dump(content), 0, ip, port)
  s.close
end

def handle_incoming_drone_request(body, sender)
  data = Marshal.load body

  drone_ip = sender[3]
  drone_port = data[:port]
  content = {:port => @queen_http_port}

  begin
    inform_drone(drone_ip, drone_port, content)
  rescue
    # Make sure thread does not crash
  end
end

def start_service_announcer
  Thread.fork do
    s = UDPSocket.new
    s.bind('0.0.0.0', @queen_udp_port)

    loop do
      body, sender = s.recvfrom(1024)
      handle_incoming_drone_request(body, sender)
    end
  end
end


start_service_announcer

puts gets
