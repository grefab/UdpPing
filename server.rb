require 'rubygems'
require 'json'
require 'socket'
require 'pp'
require 'rest-client'


udp_port = 1234
@http_port = 4567

def inform_drone(ip, port)
  url = "http://#{ip}:#{port}/queen"
  PP.pp url
  RestClient.post url, {:port => @http_port}.to_json
end

Thread.fork do
  s = UDPSocket.new
  s.bind('0.0.0.0', udp_port)

  loop do
    text, sender = s.recvfrom(1024)
    data = Marshal.load(text)

    ip = sender[3]
    port = data[:port]

    begin
      sleep 1
      inform_drone ip, port
    rescue
      # Make sure thread does not crash
    end
  end
end

puts gets
