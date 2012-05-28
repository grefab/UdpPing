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

  puts "Queen told me:"
  PP.pp data

  {:status => "received"}.to_json
end

sleep 1
udp_port = 1234
http_port = 4567
message = {:type => "drone", :port => http_port}
broadcast_msg Marshal.dump(message), udp_port

