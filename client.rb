require 'rubygems'
require 'socket'
require 'sinatra'
require 'json'
require 'pp'


def broadcast_msg(message, udp_port)
  s = UDPSocket.new
  s.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
  s.send(message, 0, '<broadcast>', udp_port)
end


post '/queen' do
  data = JSON.parse request.body.read

  PP.pp data

  ip = request.ip
  port = data["port"]

  puts "Queen told me to be at http://#{ip}:#{port}/"

  # Send something nice back
  {:status => "received"}.to_json
end

sleep 1
udp_port = 1234
http_port = 4567
message = {:type => "drone", :port => http_port}
broadcast_msg Marshal.dump(message), udp_port

