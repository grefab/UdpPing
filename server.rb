require 'rubygems'
require 'socket'
require 'pp'


@queen_udp_port = 1234
@queen_http_port = 4567

def answer_client(ip, port, response)
  s = UDPSocket.new
  s.send(Marshal.dump(response), 0, ip, port)
  s.close
end

def start_service_announcer(&code)
  Thread.fork do
    s = UDPSocket.new
    s.bind('0.0.0.0', @queen_udp_port)

    loop do
      body, sender = s.recvfrom(1024)
      data = Marshal.load body

      client_ip = sender[3]
      client_port = data[:reply_port]
      response = code.call(data[:content], sender)

      begin
        answer_client(client_ip, client_port, response)
      rescue
        # Make sure thread does not crash
      end
    end
  end
end


def reply_for_client
  {:port => @queen_http_port}
end


thread = start_service_announcer do |data, client_ip|
  reply_for_client
end

thread.join

