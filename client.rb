require_relative "udp_ping"
require "prettyprint"

SERVER_LISTEN_PORT = 1234

puts "Querying server..."

result = UDPPing.query_server("Hello", SERVER_LISTEN_PORT) do |data, server_ip|
  puts "Server answered:"
  p(server_ip: server_ip, server_answer: data)
end

puts "Query finished. Result: #{result}."
