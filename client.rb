require_relative 'udp_ping'

result = UDPPing.query_server("xxx", 1234) do |data, server_ip|
  puts "Queen: #{server_ip}:#{data[:queen_http_port]}"
end

puts result


