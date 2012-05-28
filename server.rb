require 'rubygems'
require 'json'
require 'socket'
require 'pp'
require 'rest-client'


udp_port = 1234


def inform_drone(ip, port)
  url = "http://#{ip}:#{port}/queen"
  PP.pp url
  RestClient.post url, {:message => "hello"}.to_json
end

Thread.fork do
  s = UDPSocket.new
  s.bind('0.0.0.0', udp_port)

  loop do
    text, sender = s.recvfrom(1024)
    data = Marshal.load(text)
    PP.pp data
    PP.pp sender

    ip = sender[3]
    PP.pp ip

    port = data[:port]
    PP.pp port

    sleep 3
    begin
      inform_drone ip, port
    rescue
    end
  end
end

puts gets
