require_relative 'udp_ping'

SERVER_LISTEN_PORT = 1234

puts "Starting Server..."

thread = UDPPing.start_service_announcer(SERVER_LISTEN_PORT) do |client_msg, client_ip|
  {you_are: client_ip, you_said: client_msg, i_say: "foobar!"}
end

puts "Server running."

thread.join

