require 'socket'
require 'timeout'

module UDPPing
  @drone_udp_port = 12345

  def self.answer_client(ip, port, response)
    s = UDPSocket.new
    s.send(Marshal.dump(response), 0, ip, port)
    s.close
  end

  def self.start_service_announcer(server_udp_port, &code)
    Thread.fork do
      s = UDPSocket.new
      s.bind('0.0.0.0', server_udp_port)

      loop do
        body, sender = s.recvfrom(1024)
        data = Marshal.load(body)

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

  def self.broadcast_to_potential_servers(content, udp_port)
    body = {:reply_port => @drone_udp_port, :content => content}

    s = UDPSocket.new
    s.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
    s.send(Marshal.dump(body), 0, '<broadcast>', udp_port)
    s.close
  end

  def self.start_server_listener(&code)
    Thread.fork do
      s = UDPSocket.new
      s.bind('0.0.0.0', @drone_udp_port)

      body, sender = timeout(3) { s.recvfrom(1024) }
      server_ip = sender[3]
      data = Marshal.load(body)
      code.call(data, server_ip)
    end
  end

  def self.query_server(content, server_udp_port, &code)
    thread = start_server_listener do |data, server_ip|
      code.call(data, server_ip)
    end

    broadcast_to_potential_servers(content, server_udp_port)

    begin
      thread.join
    rescue Timeout::Error
      return false
    end

    true
  end

end