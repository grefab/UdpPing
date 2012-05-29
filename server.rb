require_relative 'udp_ping'

thread = UDPPing.start_service_announcer(1234) do |data, client_ip|
  {:queen_http_port => 4567}
end

thread.join

